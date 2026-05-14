import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/chat_message.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/chat/chat_message_bubble.dart';
import '../../widgets/chat/chat_input_field.dart';
import '../../widgets/chat/chat_date_separator.dart';
import '../../utils/date_utils.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreen({
    super.key,
    required this.chatRoom,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ScrollController _scrollController;
  late TextEditingController _messageController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _messageController = TextEditingController();
    _focusNode = FocusNode();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _initializeChat() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setCurrentChatRoom(widget.chatRoom);
    chatProvider.loadMessages(widget.chatRoom.id);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, AuthProvider>(
      builder: (context, chatProvider, authProvider, child) {
        final currentUserId = authProvider.user?.id;
        final otherUserName = widget.chatRoom.getOtherUserName(currentUserId ?? '');
        
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: otherUserName,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showChatMenu(context),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildRequestInfo(),
              Expanded(
                child: _buildMessagesList(chatProvider, currentUserId),
              ),
              _buildMessageInput(chatProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRequestInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.assignment_outlined,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.chatRoom.requestTitle,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context, 
                '/request/detail',
                arguments: widget.chatRoom.requestId,
              );
            },
            child: Text(
              '상세보기',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(ChatProvider chatProvider, String? currentUserId) {
    if (chatProvider.isLoadingMessages(widget.chatRoom.id)) {
      return _buildMessagesLoadingState();
    }

    final messages = chatProvider.getMessages(widget.chatRoom.id);
    
    if (messages.isEmpty) {
      return _buildEmptyMessages();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final previousMessage = index > 0 ? messages[index - 1] : null;
        final nextMessage = index < messages.length - 1 ? messages[index + 1] : null;
        
        final showDateSeparator = previousMessage == null ||
            !AppDateUtils.isSameDay(message.createdAt, previousMessage.createdAt);
        
        final showAvatar = message.senderId != currentUserId &&
            (nextMessage == null ||
             nextMessage.senderId != message.senderId ||
             nextMessage.createdAt.difference(message.createdAt).inMinutes > 5);

        return Column(
          children: [
            if (showDateSeparator)
              ChatDateSeparator(date: message.createdAt),
            ChatMessageBubble(
              message: message,
              isMe: message.senderId == currentUserId,
              showAvatar: showAvatar,
              showTime: _shouldShowTime(message, nextMessage, currentUserId),
            ),
          ],
        );
      },
    );
  }

  bool _shouldShowTime(ChatMessage message, ChatMessage? nextMessage, String? currentUserId) {
    if (nextMessage == null) return true;
    if (nextMessage.senderId != message.senderId) return true;
    if (nextMessage.createdAt.difference(message.createdAt).inMinutes > 5) return true;
    return false;
  }

  Widget _buildMessagesLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 8,
      itemBuilder: (context, index) {
        final isMe = index % 3 == 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isMe) 
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: SkeletonLoader(width: 80, height: 12),
                    ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primary.withOpacity(0.1) : AppColors.gray.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        SkeletonLoader(
                          width: 120 + (index % 3) * 40,
                          height: 16,
                        ),
                        if (index % 4 == 0) ...[
                          const SizedBox(height: 4),
                          SkeletonLoader(
                            width: 80 + (index % 2) * 30,
                            height: 16,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            '첫 메시지를 보내보세요',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatProvider chatProvider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: ChatInputField(
          controller: _messageController,
          focusNode: _focusNode,
          onSend: (content) => _sendMessage(chatProvider, content),
          onAttachment: () => _showAttachmentOptions(context),
        ),
      ),
    );
  }

  void _sendMessage(ChatProvider chatProvider, String content) {
    if (content.trim().isEmpty) return;

    chatProvider.sendMessage(
      chatRoomId: widget.chatRoom.id,
      content: content.trim(),
    );

    _messageController.clear();
    
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('카메라'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 카메라 기능 구현
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('갤러리'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 갤러리 기능 구현
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('위치'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 위치 공유 기능 구현
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChatMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('프로필 보기'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 프로필 보기 기능 구현
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('차단하기'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 차단 기능 구현
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('신고하기'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 신고 기능 구현
              },
            ),
          ],
        ),
      ),
    );
  }
}