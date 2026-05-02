import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/simple_request_card.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryType;

  const CategoryScreen({
    super.key,
    required this.categoryType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
      ),
      title: Text(
        _getCategoryTitle(categoryType),
        style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
      ),
      actions: [
        IconButton(
          onPressed: () => _showFilterDialog(context),
          icon: const Icon(Icons.tune, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // 간단한 필터 탭 (3개만)
        _buildFilterTabs(),
        
        // 요청 목록 (한 번에 많이 보여주지 않음)
        Expanded(
          child: _buildRequestList(),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.white,
      child: Row(
        children: [
          _buildFilterChip('전체', true),
          const SizedBox(width: 8),
          _buildFilterChip('가까운 순', false),
          const SizedBox(width: 8),
          _buildFilterChip('최신 순', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: isSelected ? AppColors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildRequestList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 8, // 페이징 처리 필요
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => SimpleRequestCard(
        title: _getExampleTitle(index),
        fee: _getExampleFee(index),
        location: _getExampleLocation(index),
        time: '${index + 1}분 전',
        onTap: () => _navigateToDetail(context, index),
      ),
    );
  }

  String _getCategoryTitle(String type) {
    switch (type) {
      case 'shopping':
        return '쇼핑 도움';
      case 'delivery':
        return '배송 도움';
      case 'transport':
        return '동행 도움';
      case 'companion':
        return '기타 도움';
      default:
        return '도움 요청';
    }
  }

  String _getExampleTitle(int index) {
    switch (categoryType) {
      case 'shopping':
        return ['스타벅스 픽업', '편의점 물건', '마트 장보기', '약국 심부름'][index % 4];
      case 'delivery':
        return ['택배 전달', '음식 배달', '서류 전달', '선물 배송'][index % 4];
      case 'transport':
        return ['택시 동승', '지하철 동행', '버스 함께', '공항 동행'][index % 4];
      default:
        return '기타 도움 $index';
    }
  }

  String _getExampleFee(int index) {
    final fees = ['3,000원', '5,000원', '8,000원', '4,000원'];
    return fees[index % fees.length];
  }

  String _getExampleLocation(int index) {
    final locations = ['강남역', '홍대입구', '신촌', '명동'];
    return locations[index % locations.length];
  }

  void _showFilterDialog(BuildContext context) {
    // 상세 필터 다이얼로그
  }

  void _navigateToDetail(BuildContext context, int index) {
    Navigator.pushNamed(context, '/request-detail', arguments: 'request_${index + 1}');
  }
}