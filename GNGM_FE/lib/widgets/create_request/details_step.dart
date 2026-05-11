import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class DetailsStep extends StatelessWidget {
  final String title;
  final String description;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;

  const DetailsStep({
    super.key,
    required this.title,
    required this.description,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '요청을 설명해주세요',
            style: AppTextStyles.brandTitle,
          ),
          const SizedBox(height: 8),
          Text(
            '다른 사람들이 이해하기 쉽게 적어주세요',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          _buildTitleField(),
          const SizedBox(height: 16),
          _buildDescriptionField(),
          const SizedBox(height: 24),
          _buildHelpCard(),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      decoration: InputDecoration(
        labelText: '제목',
        hintText: '예: 스타벅스 아메리카노 픽업',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
      onChanged: onTitleChanged,
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      decoration: InputDecoration(
        labelText: '상세 설명',
        hintText: '구체적인 요청 내용을 작성해주세요',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      onChanged: onDescriptionChanged,
    );
  }

  Widget _buildHelpCard() {
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
                '작성 가이드',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• 구체적인 브랜드명이나 상품명 적기\n• 수량, 크기 등 세부사항 명시\n• 픽업 시간 및 조건 안내\n• 특별한 요구사항이 있다면 미리 설명',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}