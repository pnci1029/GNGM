import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/category_button.dart';
import '../../widgets/common/floating_action_button.dart';
import '../../providers/request_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/request.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadNearbyRequests();
  }

  void _loadNearbyRequests() {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    requestProvider.loadNearbyRequests(
      lat: 37.4980,
      lng: 127.0276,
      radius: 5.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더 (최소한의 정보만)
            _buildHeader(),
            
            // 메인 액션 카드 (핵심 기능만)
            Expanded(
              child: _buildMainContent(context),
            ),
          ],
        ),
      ),
      // 하단 고정 액션 버튼
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => _showCreateRequestDialog(context),
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 로고 + 사용자 인사
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GNGM',
                    style: AppTextStyles.brandTitle.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user != null ? '${user.name}님 안녕하세요!' : '가는김에 도움주고받기',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              
              // 알림 + 프로필 (아이콘만)
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined, size: 24),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.person_outline, size: 24),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 핵심 카테고리 4개만 (큰 버튼)
          _buildCategoryGrid(context),
          
          const SizedBox(height: 24),
          
          // 주변 요청 미리보기 (3개만)
          _buildNearbyPreview(context),
          
          const SizedBox(height: 80), // FAB 공간
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '어떤 도움이 필요하세요?',
          style: AppTextStyles.subtitle,
        ),
        const SizedBox(height: 16),
        
        // 2x2 그리드로 큰 버튼들
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            CategoryButton(
              icon: Icons.shopping_bag_outlined,
              label: '쇼핑',
              color: AppColors.primary,
              onTap: () => _navigateToCategory(context, 'shopping'),
            ),
            CategoryButton(
              icon: Icons.delivery_dining_outlined,
              label: '배송',
              color: AppColors.primaryLight,
              onTap: () => _navigateToCategory(context, 'delivery'),
            ),
            CategoryButton(
              icon: Icons.directions_car_outlined,
              label: '동행',
              color: AppColors.success,
              onTap: () => _navigateToCategory(context, 'transport'),
            ),
            CategoryButton(
              icon: Icons.handshake_outlined,
              label: '기타',
              color: AppColors.warning,
              onTap: () => _navigateToCategory(context, 'companion'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNearbyPreview(BuildContext context) {
    return Consumer<RequestProvider>(
      builder: (context, requestProvider, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '주변 요청',
                  style: AppTextStyles.subtitle,
                ),
                TextButton(
                  onPressed: () => _navigateToNearbyList(context),
                  child: Text(
                    '더보기',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (requestProvider.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (requestProvider.error != null)
              Center(
                child: Column(
                  children: [
                    Text(
                      requestProvider.error!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _loadNearbyRequests,
                      child: Text(
                        '다시 시도',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (requestProvider.requests.isEmpty)
              Center(
                child: Text(
                  '주변에 요청이 없습니다',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              Column(
                children: requestProvider.requests
                    .take(3)
                    .map((request) => _buildRequestCard(request))
                    .expand((widget) => [widget, const SizedBox(height: 8)])
                    .take(requestProvider.requests.take(3).length * 2 - 1)
                    .toList(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRequestCard(Request request) {
    return GestureDetector(
      onTap: () => _navigateToRequestDetail(context, request.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.title,
                    style: AppTextStyles.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    request.pickupAddress,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(request.createdAt),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${request.feeAmount.toStringAsFixed(0)}원',
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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

  void _navigateToCategory(BuildContext context, String category) {
    Navigator.pushNamed(context, '/category', arguments: category);
  }

  void _navigateToNearbyList(BuildContext context) {
    Navigator.pushNamed(context, '/category', arguments: 'all');
  }

  void _showCreateRequestDialog(BuildContext context) {
    Navigator.pushNamed(context, '/create-request');
  }

  void _navigateToRequestDetail(BuildContext context, String requestId) {
    Navigator.pushNamed(context, '/request-detail', arguments: requestId);
  }
}