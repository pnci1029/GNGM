import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class FeeStep extends StatelessWidget {
  final int fee;
  final Function(String) onFeeChanged;

  const FeeStep({
    super.key,
    required this.fee,
    required this.onFeeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '감사 표현은 얼마로?',
            style: AppTextStyles.brandTitle,
          ),
          const SizedBox(height: 8),
          Text(
            '도움받을 만큼의 적당한 금액을 제안해보세요',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          _buildFeeField(),
          const SizedBox(height: 24),
          _buildQuickAmountButtons(),
          const SizedBox(height: 24),
          _buildFeeGuide(),
        ],
      ),
    );
  }

  Widget _buildFeeField() {
    return TextField(
      decoration: InputDecoration(
        labelText: '제안 금액',
        hintText: '0',
        prefixIcon: Icon(
          Icons.monetization_on_outlined,
          color: AppColors.primary,
        ),
        suffix: Text(
          '원',
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
      keyboardType: TextInputType.number,
      onChanged: onFeeChanged,
    );
  }

  Widget _buildQuickAmountButtons() {
    final amounts = [3000, 5000, 8000, 10000, 15000];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '빠른 선택',
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amounts.map((amount) => _buildAmountChip(amount)).toList(),
        ),
      ],
    );
  }

  Widget _buildAmountChip(int amount) {
    final isSelected = fee == amount;
    
    return GestureDetector(
      onTap: () => onFeeChanged(amount.toString()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          '${amount.toString()}원',
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFeeGuide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryPale,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '적정 금액 가이드',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGuideItem('커피 픽업', '3,000 ~ 5,000원', Icons.coffee_outlined),
          const SizedBox(height: 8),
          _buildGuideItem('간단한 배송', '5,000 ~ 8,000원', Icons.delivery_dining_outlined),
          const SizedBox(height: 8),
          _buildGuideItem('택시 동승', '실제 요금의 50%', Icons.directions_car_outlined),
          const SizedBox(height: 8),
          _buildGuideItem('기타 심부름', '시간 x 5,000원', Icons.handshake_outlined),
        ],
      ),
    );
  }

  Widget _buildGuideItem(String title, String amount, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          amount,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}