import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../screens/category/category_screen.dart';

class CategoryFilterBar extends StatelessWidget {
  final String searchQuery;
  final SortOption selectedSort;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Function(SortOption) onSortChanged;

  const CategoryFilterBar({
    super.key,
    required this.searchQuery,
    required this.selectedSort,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildFilterTabs(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: '제목이나 내용으로 검색...',
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textSecondary.withOpacity(0.7),
              size: 20,
            ),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();
                      onSearchChanged('');
                    },
                    icon: Icon(
                      Icons.clear,
                      color: AppColors.textSecondary.withOpacity(0.7),
                      size: 18,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          onChanged: onSearchChanged,
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('전체', SortOption.all),
            const SizedBox(width: 8),
            _buildFilterChip('가까운 순', SortOption.distance),
            const SizedBox(width: 8),
            _buildFilterChip('최신 순', SortOption.recent),
            const SizedBox(width: 8),
            _buildFilterChip('높은 가격순', SortOption.priceHigh),
            const SizedBox(width: 8),
            _buildFilterChip('낮은 가격순', SortOption.priceLow),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, SortOption option) {
    final isSelected = selectedSort == option;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onSortChanged(option),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}