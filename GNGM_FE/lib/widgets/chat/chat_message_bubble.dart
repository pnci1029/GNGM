import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/chat_message.dart';
import '../../utils/date_utils.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool showAvatar;
  final bool showTime;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.showAvatar,
    required this.showTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _buildAvatar(),
          if (!isMe) const SizedBox(width: 8),
          Flexible(child: _buildMessageContent()),
          if (isMe) const SizedBox(width: 8),
          if (showTime) _buildTimeAndStatus(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: showAvatar ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: showAvatar
          ? Center(
              child: Text(
                message.senderName.isNotEmpty ? message.senderName[0] : '?',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case ChatMessageType.text:
        return _buildTextMessage();
      case ChatMessageType.image:
        return _buildImageMessage();
      case ChatMessageType.location:
        return _buildLocationMessage();
      case ChatMessageType.offer:
        return _buildOfferMessage();
      case ChatMessageType.system:
        return _buildSystemMessage();
    }
  }

  Widget _buildTextMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        message.content,
        style: AppTextStyles.body.copyWith(
          color: isMe ? AppColors.white : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildImageMessage() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image, size: 48),
          const SizedBox(height: 8),
          Text(
            '이미지',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary.withOpacity(0.1) : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '위치가 공유되었습니다',
            style: AppTextStyles.body.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferMessage() {
    final metadata = message.metadata;
    final amount = metadata?['amount']?.toString() ?? '0';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_money,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '제안',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message.content,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '제안 금액: ${amount}원',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message.content,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTimeAndStatus() {
    return Column(
      children: [
        if (showTime)
          Text(
            AppDateUtils.formatMessageTime(message.createdAt),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        if (isMe && message.isRead) ...[
          const SizedBox(height: 2),
          Icon(
            Icons.done_all,
            color: AppColors.primary,
            size: 12,
          ),
        ],
      ],
    );
  }
}