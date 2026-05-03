import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/simple_request_card.dart';
import '../../providers/request_provider.dart';
import '../../models/request.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryType;

  const CategoryScreen({
    super.key,
    required this.categoryType,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    requestProvider.loadRequests(
      categoryType: widget.categoryType == 'all' ? null : widget.categoryType,
    );
  }

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
        _getCategoryTitle(widget.categoryType),
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
    return Consumer<RequestProvider>(
      builder: (context, requestProvider, child) {
        if (requestProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (requestProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  requestProvider.error!,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadRequests,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          );
        }

        if (requestProvider.requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  '요청이 없습니다',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: requestProvider.requests.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final request = requestProvider.requests[index];
            return SimpleRequestCard(
              title: request.title,
              fee: '${request.feeAmount.toStringAsFixed(0)}원',
              location: request.pickupAddress,
              time: _formatTime(request.createdAt),
              onTap: () => _navigateToDetail(context, request.id),
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else {
      return '${difference.inDays}일 전';
    }
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

  void _showFilterDialog(BuildContext context) {
    // 상세 필터 다이얼로그
  }

  void _navigateToDetail(BuildContext context, String requestId) {
    Navigator.pushNamed(context, '/request-detail', arguments: requestId);
  }
}