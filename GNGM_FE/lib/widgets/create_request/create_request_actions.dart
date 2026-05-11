import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class CreateRequestActions extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isSubmitting;
  final bool canProceed;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const CreateRequestActions({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isSubmitting,
    required this.canProceed,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (currentStep > 0) ...[
              Expanded(
                child: _buildPreviousButton(),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: _buildNextButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousButton() {
    return OutlinedButton(
      onPressed: onPrevious,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.border),
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            '이전',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    final isLastStep = currentStep == totalSteps - 1;
    
    return ElevatedButton(
      onPressed: canProceed && !isSubmitting ? onNext : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: canProceed ? 2 : 0,
      ),
      child: isSubmitting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastStep ? '요청 등록하기' : '다음',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!isLastStep) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.white,
                  ),
                ],
              ],
            ),
    );
  }
}