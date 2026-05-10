import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/simple_request_card.dart';
import '../../providers/request_provider.dart';
import '../../models/request.dart';

class CategoryRequestList extends StatelessWidget {
  final List<Request> filteredRequests;
  final String searchQuery;
  final Function() onRetry;
  final Function(BuildContext, String) onNavigateToDetail;

  const CategoryRequestList({
    super.key,
    required this.filteredRequests,
    required this.searchQuery,
    required this.onRetry,
    required this.onNavigateToDetail,
  });

  @override
  Widget build(BuildContext context) {
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
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          );
        }

        if (filteredRequests.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filteredRequests.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final request = filteredRequests[index];
            return SimpleRequestCard(
              title: request.title,
              fee: '${request.feeAmount.toStringAsFixed(0)}원',
              location: request.pickupAddress,
              time: _formatTime(request.createdAt),
              onTap: () => onNavigateToDetail(context, request.id),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryPale,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.primary.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            searchQuery.isNotEmpty ? '검색 결과가 없습니다' : '요청이 없습니다',
            style: AppTextStyles.subtitle.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty 
                ? '다른 검색어로 다시 시도해보세요'
                : '새로운 요청이 등록되면 알려드릴게요',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? createdAt) {
    if (createdAt == null) return '알 수 없음';
    
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
}