const jwt = require('jsonwebtoken');
const { ChatRoom, ChatMessage, User } = require('../models');

const authenticateSocket = async (socket, next) => {
  try {
    const token = socket.handshake.auth.token;
    if (!token) {
      return next(new Error('Authentication failed'));
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findByPk(decoded.id);
    
    if (!user) {
      return next(new Error('User not found'));
    }

    socket.userId = user.id;
    socket.user = user;
    next();
  } catch (error) {
    next(new Error('Authentication failed'));
  }
};

module.exports = (io) => {
  // Authentication middleware
  io.use(authenticateSocket);

  // Connection handling
  io.on('connection', (socket) => {
    console.log(`💬 User ${socket.user.name} connected to chat`);

    // Join user to their personal room for notifications
    socket.join(`user_${socket.userId}`);

    // Handle joining a chat room
    socket.on('joinRoom', async (data) => {
      try {
        const { chatRoomId } = data;
        
        // Verify user has access to this chat room
        const chatRoom = await ChatRoom.findOne({
          where: {
            id: chatRoomId,
            $or: [
              { requesterId: socket.userId },
              { providerId: socket.userId }
            ]
          }
        });

        if (!chatRoom) {
          socket.emit('error', { message: 'Access denied to chat room' });
          return;
        }

        // Leave previous rooms (except user room)
        const rooms = Array.from(socket.rooms);
        rooms.forEach(room => {
          if (room !== socket.id && !room.startsWith('user_')) {
            socket.leave(room);
          }
        });

        // Join the chat room
        socket.join(`chat_${chatRoomId}`);
        socket.currentChatRoom = chatRoomId;

        // Load recent messages
        const messages = await ChatMessage.findAll({
          where: { chatRoomId },
          include: [{
            model: User,
            as: 'sender',
            attributes: ['id', 'name', 'profileImage']
          }],
          order: [['createdAt', 'DESC']],
          limit: 50
        });

        socket.emit('roomJoined', {
          chatRoomId,
          messages: messages.reverse()
        });

        // Mark messages as read
        await ChatMessage.update(
          { isRead: true, readAt: new Date() },
          {
            where: {
              chatRoomId,
              senderId: { $ne: socket.userId },
              isRead: false
            }
          }
        );

        console.log(`💬 User ${socket.user.name} joined chat room ${chatRoomId}`);
      } catch (error) {
        console.error('Error joining room:', error);
        socket.emit('error', { message: 'Failed to join chat room' });
      }
    });

    // Handle sending a message
    socket.on('sendMessage', async (data) => {
      try {
        const { chatRoomId, content, messageType = 'text' } = data;

        // Verify user is in the chat room
        if (socket.currentChatRoom !== chatRoomId) {
          socket.emit('error', { message: 'Not joined to this chat room' });
          return;
        }

        // Create the message
        const message = await ChatMessage.create({
          chatRoomId,
          senderId: socket.userId,
          content,
          messageType
        });

        // Load message with sender info
        const fullMessage = await ChatMessage.findByPk(message.id, {
          include: [{
            model: User,
            as: 'sender',
            attributes: ['id', 'name', 'profileImage']
          }]
        });

        // Update chat room's last message time
        await ChatRoom.update(
          { lastMessageAt: new Date() },
          { where: { id: chatRoomId } }
        );

        // Broadcast to all users in the chat room
        io.to(`chat_${chatRoomId}`).emit('newMessage', fullMessage);

        // Send push notification to other user if they're not in the room
        const chatRoom = await ChatRoom.findByPk(chatRoomId);
        const otherUserId = chatRoom.requesterId === socket.userId 
          ? chatRoom.providerId 
          : chatRoom.requesterId;

        const otherUserSockets = io.sockets.adapter.rooms.get(`user_${otherUserId}`);
        const isOtherUserInRoom = io.sockets.adapter.rooms.get(`chat_${chatRoomId}`)?.size > 1;

        if (otherUserSockets && !isOtherUserInRoom) {
          io.to(`user_${otherUserId}`).emit('newMessageNotification', {
            chatRoomId,
            message: fullMessage,
            sender: socket.user
          });
        }

        console.log(`💬 Message sent in room ${chatRoomId} by ${socket.user.name}`);
      } catch (error) {
        console.error('Error sending message:', error);
        socket.emit('error', { message: 'Failed to send message' });
      }
    });

    // Handle typing indicators
    socket.on('typing', (data) => {
      if (socket.currentChatRoom) {
        socket.to(`chat_${socket.currentChatRoom}`).emit('userTyping', {
          userId: socket.userId,
          userName: socket.user.name,
          isTyping: data.isTyping
        });
      }
    });

    // Handle disconnection
    socket.on('disconnect', () => {
      console.log(`💬 User ${socket.user.name} disconnected from chat`);
    });

    // Handle errors
    socket.on('error', (error) => {
      console.error('Socket error:', error);
    });
  });

  console.log('💬 Socket.IO chat handler initialized');
};