import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class CategoryStep extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryStep({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'id': 'shopping', 'name': '쇼핑', 'icon': Icons.shopping_bag_outlined, 'color': AppColors.primary},
      {'id': 'delivery', 'name': '배송', 'icon': Icons.delivery_dining_outlined, 'color': AppColors.primaryLight},
      {'id': 'transport', 'name': '동행', 'icon': Icons.directions_car_outlined, 'color': AppColors.success},
      {'id': 'companion', 'name': '기타', 'icon': Icons.handshake_outlined, 'color': AppColors.warning},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '어떤 도움이 필요하세요?',
            style: AppTextStyles.brandTitle,
          ),
          const SizedBox(height: 8),
          Text(
            '카테고리를 선택해주세요',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category['id'];
                
                return _buildCategoryCard(category, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, bool isSelected) {
    return GestureDetector(
      onTap: () => onCategorySelected(category['id'] as String),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected 
              ? (category['color'] as Color).withOpacity(0.1) 
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? (category['color'] as Color) 
                : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: (category['color'] as Color).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'] as IconData,
              size: 32,
              color: category['color'] as Color,
            ),
            const SizedBox(height: 8),
            Text(
              category['name'] as String,
              style: AppTextStyles.body.copyWith(
                color: category['color'] as Color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}