import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/chat_message.dart';
import '../../providers/auth_provider.dart';
import '../../utils/date_utils.dart';

class ChatRoomCard extends StatelessWidget {
  final ChatRoom chatRoom;
  final VoidCallback onTap;

  const ChatRoomCard({
    super.key,
    required this.chatRoom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final currentUserId = authProvider.user?.id;
        final otherUserName = chatRoom.getOtherUserName(currentUserId ?? '');
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            shadowColor: AppColors.shadow,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(otherUserName),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(otherUserName, context),
                          const SizedBox(height: 4),
                          _buildRequestTitle(),
                          const SizedBox(height: 6),
                          _buildLastMessage(),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildTime(),
                        const SizedBox(height: 8),
                        _buildUnreadBadge(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(String otherUserName) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          otherUserName.isNotEmpty ? otherUserName[0] : '?',
          style: AppTextStyles.body.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String otherUserName, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            otherUserName,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    String statusText;
    
    switch (chatRoom.status) {
      case ChatRoomStatus.active:
        statusColor = AppColors.success;
        statusText = '활성';
        break;
      case ChatRoomStatus.completed:
        statusColor = AppColors.textSecondary;
        statusText = '완료';
        break;
      case ChatRoomStatus.cancelled:
        statusColor = AppColors.error;
        statusText = '취소';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusText,
        style: AppTextStyles.caption.copyWith(
          color: statusColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRequestTitle() {
    return Text(
      chatRoom.requestTitle,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLastMessage() {
    if (chatRoom.lastMessage == null) {
      return Text(
        '채팅을 시작해보세요',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    final lastMessage = chatRoom.lastMessage!;
    String messageText;
    
    switch (lastMessage.type) {
      case ChatMessageType.text:
        messageText = lastMessage.content;
        break;
      case ChatMessageType.image:
        messageText = '📷 사진';
        break;
      case ChatMessageType.location:
        messageText = '📍 위치';
        break;
      case ChatMessageType.offer:
        messageText = '💰 제안';
        break;
      case ChatMessageType.system:
        messageText = lastMessage.content;
        break;
    }

    return Text(
      messageText,
      style: AppTextStyles.caption.copyWith(
        color: chatRoom.unreadCount > 0 
            ? AppColors.textPrimary 
            : AppColors.textSecondary,
        fontWeight: chatRoom.unreadCount > 0 
            ? FontWeight.w600 
            : FontWeight.normal,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTime() {
    return Text(
      AppDateUtils.formatChatTime(chatRoom.lastMessageAt),
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textSecondary,
        fontSize: 11,
      ),
    );
  }

  Widget _buildUnreadBadge() {
    if (chatRoom.unreadCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        chatRoom.unreadCount > 99 ? '99+' : '${chatRoom.unreadCount}',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}