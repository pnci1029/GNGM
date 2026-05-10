import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/category/category_filter_bar.dart';
import '../../widgets/category/category_request_list.dart';
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
        // 검색바 + 필터 탭
        CategoryFilterBar(
          searchQuery: _searchQuery,
          selectedSort: _selectedSort,
          searchController: _searchController,
          onSearchChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            if (value.length >= 2) {
              _loadRequests();
            } else if (value.isEmpty) {
              _loadRequests();
            }
          },
          onSortChanged: (option) {
            setState(() {
              _selectedSort = option;
            });
            _loadRequests();
          },
        ),
        
        // 요청 목록
        Expanded(
          child: CategoryRequestList(
            filteredRequests: _getFilteredRequests(
              Provider.of<RequestProvider>(context).requests),
            searchQuery: _searchQuery,
            onRetry: _loadRequests,
            onNavigateToDetail: _navigateToDetail,
          ),
        ),
      ],
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