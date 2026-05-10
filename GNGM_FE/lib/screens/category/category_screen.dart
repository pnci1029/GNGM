import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/simple_request_card.dart';
import '../../providers/request_provider.dart';
import '../../providers/location_provider.dart';
import '../../models/request.dart';

enum SortOption { all, distance, recent, priceHigh, priceLow }

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
  SortOption _selectedSort = SortOption.all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadRequests() {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    
    if (_selectedSort == SortOption.distance) {
      requestProvider.loadNearbyRequests(
        lat: locationProvider.latitude,
        lng: locationProvider.longitude,
        radius: 5.0,
        categoryType: widget.categoryType == 'all' ? null : widget.categoryType,
      );
    } else {
      requestProvider.loadRequests(
        categoryType: widget.categoryType == 'all' ? null : widget.categoryType,
      );
    }
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
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.only(left: 8),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: 16,
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getCategoryTitle(widget.categoryType),
            style: AppTextStyles.title.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_searchQuery.isNotEmpty)
            Text(
              "'$_searchQuery' 검색 결과",
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () => _showFilterDialog(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // 검색바
        _buildSearchBar(),
        
        // 필터 탭
        _buildFilterTabs(),
        
        // 요청 목록
        Expanded(
          child: _buildRequestList(),
        ),
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
          controller: _searchController,
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
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                      _loadRequests();
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
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            if (value.length >= 2) {
              _loadRequests();
            } else if (value.isEmpty) {
              _loadRequests();
            }
          },
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
    final isSelected = _selectedSort == option;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedSort = option;
            });
            _loadRequests();
          },
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
                  _searchQuery.isNotEmpty ? '검색 결과가 없습니다' : '요청이 없습니다',
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _searchQuery.isNotEmpty 
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

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _getFilteredRequests(requestProvider.requests).length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final filteredRequests = _getFilteredRequests(requestProvider.requests);
            final request = filteredRequests[index];
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

  List<Request> _getFilteredRequests(List<Request> requests) {
    List<Request> filteredRequests = requests;

    // 검색어 필터링
    if (_searchQuery.isNotEmpty) {
      filteredRequests = filteredRequests.where((request) {
        return request.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            request.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            request.pickupAddress.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // 정렬 적용
    switch (_selectedSort) {
      case SortOption.all:
        // 기본 정렬 (최신순)
        filteredRequests.sort((a, b) => 
            (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
        break;
      case SortOption.recent:
        filteredRequests.sort((a, b) => 
            (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
        break;
      case SortOption.priceHigh:
        filteredRequests.sort((a, b) => b.feeAmount.compareTo(a.feeAmount));
        break;
      case SortOption.priceLow:
        filteredRequests.sort((a, b) => a.feeAmount.compareTo(b.feeAmount));
        break;
      case SortOption.distance:
        // 거리순은 이미 loadNearbyRequests에서 처리됨
        break;
    }

    return filteredRequests;
  }
}