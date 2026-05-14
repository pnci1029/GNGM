import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';
import '../utils/error_handler.dart';
import 'auth_provider.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AuthProvider _authProvider;
  WebSocketService? _webSocketService;

  List<ChatRoom> _chatRooms = [];
  Map<String, List<ChatMessage>> _chatMessages = {};
  Map<String, bool> _isLoadingMessages = {};
  bool _isLoadingRooms = false;
  String? _error;
  ChatRoom? _currentChatRoom;

  ChatProvider({
    required ApiService apiService,
    required AuthProvider authProvider,
  })  : _apiService = apiService,
        _authProvider = authProvider {
    _initWebSocket();
  }

  List<ChatRoom> get chatRooms => List.unmodifiable(_chatRooms);
  Map<String, List<ChatMessage>> get chatMessages => Map.unmodifiable(_chatMessages);
  bool get isLoadingRooms => _isLoadingRooms;
  String? get error => _error;
  ChatRoom? get currentChatRoom => _currentChatRoom;
  
  bool isLoadingMessages(String chatRoomId) => _isLoadingMessages[chatRoomId] ?? false;
  List<ChatMessage> getMessages(String chatRoomId) => _chatMessages[chatRoomId] ?? [];

  void _initWebSocket() {
    if (_authProvider.isLoggedIn && _authProvider.token != null) {
      _webSocketService = WebSocketService(token: _authProvider.token!);
      _webSocketService?.connect();
      _webSocketService?.onMessageReceived = _handleNewMessage;
      _webSocketService?.onRoomUpdated = _handleRoomUpdate;
    }
  }

  void _handleNewMessage(ChatMessage message) {
    final chatRoomId = message.chatRoomId;
    
    if (!_chatMessages.containsKey(chatRoomId)) {
      _chatMessages[chatRoomId] = [];
    }
    
    _chatMessages[chatRoomId]!.add(message);
    
    final roomIndex = _chatRooms.indexWhere((room) => room.id == chatRoomId);
    if (roomIndex != -1) {
      final room = _chatRooms[roomIndex];
      final updatedRoom = room.copyWith(
        lastMessage: message,
        lastMessageAt: message.createdAt,
        unreadCount: message.senderId != _authProvider.user?.id 
            ? room.unreadCount + 1 
            : room.unreadCount,
      );
      _chatRooms[roomIndex] = updatedRoom;
      _chatRooms.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    }
    
    notifyListeners();
  }

  void _handleRoomUpdate(ChatRoom room) {
    final index = _chatRooms.indexWhere((r) => r.id == room.id);
    if (index != -1) {
      _chatRooms[index] = room;
    } else {
      _chatRooms.insert(0, room);
    }
    _chatRooms.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    notifyListeners();
  }

  Future<void> loadChatRooms() async {
    if (!_authProvider.isLoggedIn) return;

    _isLoadingRooms = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/chat/rooms');
      final List<dynamic> roomsData = response['data'] ?? [];
      _chatRooms = roomsData.map((data) => ChatRoom.fromJson(data)).toList();
      _chatRooms.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
    } finally {
      _isLoadingRooms = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages(String chatRoomId) async {
    if (!_authProvider.isLoggedIn) return;

    _isLoadingMessages[chatRoomId] = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/chat/rooms/$chatRoomId/messages');
      final List<dynamic> messagesData = response['data'] ?? [];
      final messages = messagesData.map((data) => ChatMessage.fromJson(data)).toList();
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      _chatMessages[chatRoomId] = messages;
      
      await markMessagesAsRead(chatRoomId);
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
    } finally {
      _isLoadingMessages[chatRoomId] = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String content,
    ChatMessageType type = ChatMessageType.text,
    Map<String, dynamic>? metadata,
  }) async {
    if (!_authProvider.isLoggedIn || content.trim().isEmpty) return;

    final tempMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      chatRoomId: chatRoomId,
      senderId: _authProvider.user!.id,
      senderName: _authProvider.user!.name,
      content: content.trim(),
      createdAt: DateTime.now(),
      type: type,
      metadata: metadata,
    );

    if (!_chatMessages.containsKey(chatRoomId)) {
      _chatMessages[chatRoomId] = [];
    }
    _chatMessages[chatRoomId]!.add(tempMessage);
    notifyListeners();

    try {
      final requestData = {
        'content': content.trim(),
        'type': type.name,
        if (metadata != null) 'metadata': metadata,
      };

      await _apiService.post('/chat/rooms/$chatRoomId/messages', data: requestData);
      
      _webSocketService?.sendMessage(chatRoomId, content, type: type, metadata: metadata);
    } catch (e) {
      _chatMessages[chatRoomId]?.removeLast();
      _error = ErrorHandler.getErrorMessage(e);
      notifyListeners();
    }
  }

  Future<ChatRoom?> createChatRoom(String offerId) async {
    if (!_authProvider.isLoggedIn) return null;

    try {
      final response = await _apiService.post('/chat/rooms/offer/$offerId', data: {});
      final roomData = response['data'];
      final room = ChatRoom.fromJson(roomData);
      
      _chatRooms.insert(0, room);
      notifyListeners();
      
      return room;
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
      notifyListeners();
      return null;
    }
  }

  Future<void> markMessagesAsRead(String chatRoomId) async {
    if (!_authProvider.isLoggedIn) return;

    try {
      await _apiService.put('/chat/rooms/$chatRoomId/read', data: {});
      
      final roomIndex = _chatRooms.indexWhere((room) => room.id == chatRoomId);
      if (roomIndex != -1) {
        _chatRooms[roomIndex] = _chatRooms[roomIndex].copyWith(unreadCount: 0);
      }
      
      final messages = _chatMessages[chatRoomId];
      if (messages != null) {
        for (int i = 0; i < messages.length; i++) {
          if (messages[i].senderId != _authProvider.user?.id && messages[i].readAt == null) {
            messages[i] = messages[i].copyWith(readAt: DateTime.now());
          }
        }
      }
      
      notifyListeners();
    } catch (e) {
      // 읽음 처리 실패는 사용자에게 보이지 않게 처리
    }
  }

  void setCurrentChatRoom(ChatRoom? room) {
    _currentChatRoom = room;
    if (room != null) {
      markMessagesAsRead(room.id);
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  int get totalUnreadCount {
    return _chatRooms.fold(0, (sum, room) => sum + room.unreadCount);
  }

  void dispose() {
    _webSocketService?.disconnect();
    super.dispose();
  }
}