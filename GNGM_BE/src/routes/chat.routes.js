const express = require('express');
const { ChatRoom, ChatMessage, User, ServiceRequest, ServiceOffer } = require('../models');
const { authenticate } = require('../middleware/auth.middleware');
const { Op } = require('sequelize');

const router = express.Router();

// Apply authentication middleware to all routes
router.use(authenticate);

// Get all chat rooms for the authenticated user
router.get('/rooms', async (req, res) => {
  try {
    const userId = req.user.id;
    
    const chatRooms = await ChatRoom.findAll({
      where: {
        [Op.or]: [
          { requesterId: userId },
          { providerId: userId }
        ],
        status: 'active'
      },
      include: [
        {
          model: User,
          as: 'requester',
          attributes: ['id', 'name', 'profileImage']
        },
        {
          model: User,
          as: 'provider',
          attributes: ['id', 'name', 'profileImage']
        },
        {
          model: ServiceRequest,
          as: 'request',
          attributes: ['id', 'title', 'categoryType']
        },
        {
          model: ServiceOffer,
          as: 'offer',
          attributes: ['id', 'offeredFee']
        },
        {
          model: ChatMessage,
          as: 'messages',
          limit: 1,
          order: [['createdAt', 'DESC']],
          include: [{
            model: User,
            as: 'sender',
            attributes: ['id', 'name']
          }]
        }
      ],
      order: [['lastMessageAt', 'DESC'], ['createdAt', 'DESC']]
    });

    // Add unread message count for each chat room
    const chatRoomsWithUnread = await Promise.all(chatRooms.map(async (room) => {
      const unreadCount = await ChatMessage.count({
        where: {
          chatRoomId: room.id,
          senderId: { [Op.ne]: userId },
          isRead: false
        }
      });

      return {
        ...room.toJSON(),
        unreadCount,
        otherUser: room.requesterId === userId ? room.provider : room.requester
      };
    }));

    res.json({
      success: true,
      data: chatRoomsWithUnread
    });
  } catch (error) {
    console.error('Error fetching chat rooms:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch chat rooms'
    });
  }
});

// Get messages for a specific chat room
router.get('/rooms/:roomId/messages', async (req, res) => {
  try {
    const { roomId } = req.params;
    const { page = 1, limit = 50 } = req.query;
    const userId = req.user.id;

    // Verify user has access to this chat room
    const chatRoom = await ChatRoom.findOne({
      where: {
        id: roomId,
        [Op.or]: [
          { requesterId: userId },
          { providerId: userId }
        ]
      }
    });

    if (!chatRoom) {
      return res.status(403).json({
        success: false,
        message: 'Access denied to this chat room'
      });
    }

    const offset = (page - 1) * limit;
    const messages = await ChatMessage.findAndCountAll({
      where: { chatRoomId: roomId },
      include: [{
        model: User,
        as: 'sender',
        attributes: ['id', 'name', 'profileImage']
      }],
      order: [['createdAt', 'DESC']],
      limit: parseInt(limit),
      offset: offset
    });

    res.json({
      success: true,
      data: {
        messages: messages.rows.reverse(),
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total: messages.count,
          totalPages: Math.ceil(messages.count / limit)
        }
      }
    });
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch messages'
    });
  }
});

// Mark messages as read
router.put('/rooms/:roomId/read', async (req, res) => {
  try {
    const { roomId } = req.params;
    const userId = req.user.id;

    // Verify user has access to this chat room
    const chatRoom = await ChatRoom.findOne({
      where: {
        id: roomId,
        [Op.or]: [
          { requesterId: userId },
          { providerId: userId }
        ]
      }
    });

    if (!chatRoom) {
      return res.status(403).json({
        success: false,
        message: 'Access denied to this chat room'
      });
    }

    // Mark all unread messages as read
    await ChatMessage.update(
      { isRead: true, readAt: new Date() },
      {
        where: {
          chatRoomId: roomId,
          senderId: { [Op.ne]: userId },
          isRead: false
        }
      }
    );

    res.json({
      success: true,
      message: 'Messages marked as read'
    });
  } catch (error) {
    console.error('Error marking messages as read:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to mark messages as read'
    });
  }
});

// Get or create chat room for a specific offer
router.post('/rooms/offer/:offerId', async (req, res) => {
  try {
    const { offerId } = req.params;
    const userId = req.user.id;

    // Get the offer with related request
    const offer = await ServiceOffer.findByPk(offerId, {
      include: [{
        model: ServiceRequest,
        as: 'serviceRequest'
      }]
    });

    if (!offer) {
      return res.status(404).json({
        success: false,
        message: 'Offer not found'
      });
    }

    // Check if user is either the requester or provider
    const isRequester = offer.serviceRequest.userId === userId;
    const isProvider = offer.providerId === userId;

    if (!isRequester && !isProvider) {
      return res.status(403).json({
        success: false,
        message: 'You are not authorized to access this chat'
      });
    }

    // Check if chat room already exists
    let chatRoom = await ChatRoom.findOne({
      where: {
        requestId: offer.requestId,
        offerId: offerId
      },
      include: [
        {
          model: User,
          as: 'requester',
          attributes: ['id', 'name', 'profileImage']
        },
        {
          model: User,
          as: 'provider',
          attributes: ['id', 'name', 'profileImage']
        }
      ]
    });

    // Create chat room if it doesn't exist
    if (!chatRoom) {
      chatRoom = await ChatRoom.create({
        requestId: offer.requestId,
        offerId: offerId,
        requesterId: offer.serviceRequest.userId,
        providerId: offer.providerId,
        status: 'active'
      });

      // Reload with associations
      chatRoom = await ChatRoom.findByPk(chatRoom.id, {
        include: [
          {
            model: User,
            as: 'requester',
            attributes: ['id', 'name', 'profileImage']
          },
          {
            model: User,
            as: 'provider',
            attributes: ['id', 'name', 'profileImage']
          }
        ]
      });
    }

    res.json({
      success: true,
      data: {
        ...chatRoom.toJSON(),
        otherUser: chatRoom.requesterId === userId ? chatRoom.provider : chatRoom.requester
      }
    });
  } catch (error) {
    console.error('Error creating/getting chat room:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create or get chat room'
    });
  }
});

// Get unread message count across all chat rooms
router.get('/unread-count', async (req, res) => {
  try {
    const userId = req.user.id;

    // Get all chat room IDs where user is participant
    const chatRooms = await ChatRoom.findAll({
      where: {
        [Op.or]: [
          { requesterId: userId },
          { providerId: userId }
        ],
        status: 'active'
      },
      attributes: ['id']
    });

    const roomIds = chatRooms.map(room => room.id);

    // Count unread messages across all rooms
    const unreadCount = await ChatMessage.count({
      where: {
        chatRoomId: { [Op.in]: roomIds },
        senderId: { [Op.ne]: userId },
        isRead: false
      }
    });

    res.json({
      success: true,
      data: { unreadCount }
    });
  } catch (error) {
    console.error('Error fetching unread count:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch unread count'
    });
  }
});

module.exports = router;