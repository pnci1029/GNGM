class ChatMessage {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime createdAt;
  final DateTime? readAt;
  final ChatMessageType type;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.createdAt,
    this.readAt,
    this.type = ChatMessageType.text,
    this.metadata,
  });

  bool get isRead => readAt != null;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      chatRoomId: json['chatRoomId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] != null 
          ? DateTime.parse(json['readAt'] as String) 
          : null,
      type: ChatMessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ChatMessageType.text,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'type': type.name,
      'metadata': metadata,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? chatRoomId,
    String? senderId,
    String? senderName,
    String? content,
    DateTime? createdAt,
    DateTime? readAt,
    ChatMessageType? type,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum ChatMessageType {
  text,
  image,
  system,
  offer,
  location,
}

class ChatRoom {
  final String id;
  final String requestId;
  final String requestTitle;
  final String requesterId;
  final String requesterName;
  final String providerId;
  final String providerName;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final ChatRoomStatus status;

  ChatRoom({
    required this.id,
    required this.requestId,
    required this.requestTitle,
    required this.requesterId,
    required this.requesterName,
    required this.providerId,
    required this.providerName,
    required this.createdAt,
    required this.lastMessageAt,
    this.lastMessage,
    this.unreadCount = 0,
    this.status = ChatRoomStatus.active,
  });

  String getOtherUserName(String currentUserId) {
    return currentUserId == requesterId ? providerName : requesterName;
  }

  String getOtherUserId(String currentUserId) {
    return currentUserId == requesterId ? providerId : requesterId;
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      requestTitle: json['requestTitle'] as String,
      requesterId: json['requesterId'] as String,
      requesterName: json['requesterName'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      lastMessage: json['lastMessage'] != null 
          ? ChatMessage.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      status: ChatRoomStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ChatRoomStatus.active,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestId': requestId,
      'requestTitle': requestTitle,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'providerId': providerId,
      'providerName': providerName,
      'createdAt': createdAt.toIso8601String(),
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'status': status.name,
    };
  }

  ChatRoom copyWith({
    String? id,
    String? requestId,
    String? requestTitle,
    String? requesterId,
    String? requesterName,
    String? providerId,
    String? providerName,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    ChatMessage? lastMessage,
    int? unreadCount,
    ChatRoomStatus? status,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      requestTitle: requestTitle ?? this.requestTitle,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      status: status ?? this.status,
    );
  }
}

enum ChatRoomStatus {
  active,
  completed,
  cancelled,
}