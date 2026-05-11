import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../providers/offer_provider.dart';
import '../../models/request.dart';

class OfferCreationDialog extends StatelessWidget {
  final Request request;
  final Function(String requestId, String? message, int? offeredFee) onSubmitOffer;

  const OfferCreationDialog({
    super.key,
    required this.request,
    required this.onSubmitOffer,
  });

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();
    final feeController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '도움 제안하기',
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 4),
          Text(
            '${request.title}에 대한 제안을 작성해주세요.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          _buildMessageField(messageController),
          const SizedBox(height: 16),
          _buildFeeField(feeController),
          const SizedBox(height: 24),
          _buildActionButtons(context, messageController, feeController),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMessageField(TextEditingController messageController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '메시지 (선택)',
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: messageController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '어떤 도움을 드릴 수 있는지 간단히 설명해주세요',
            hintStyle: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeeField(TextEditingController feeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '희망 수수료 (선택)',
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: feeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '원하는 수수료를 입력하세요',
            hintStyle: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            suffixText: '원',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context, 
    TextEditingController messageController,
    TextEditingController feeController,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(0, 48),
            ),
            child: Text(
              '취소',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Consumer<OfferProvider>(
            builder: (context, offerProvider, child) {
              return ElevatedButton(
                onPressed: offerProvider.isLoading
                    ? null
                    : () => onSubmitOffer(
                          request.id,
                          messageController.text.trim().isEmpty
                              ? null
                              : messageController.text.trim(),
                          feeController.text.trim().isEmpty
                              ? null
                              : int.tryParse(feeController.text.trim()),
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(0, 48),
                ),
                child: offerProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        '제안하기',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}