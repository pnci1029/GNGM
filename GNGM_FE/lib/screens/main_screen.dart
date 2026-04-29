import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../widgets/category_item.dart';
import '../widgets/service_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GNGMColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildMapSection(),
            _buildSearchSection(),
            _buildCategoriesSection(),
            _buildServiceList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: GNGMColors.primary,
        boxShadow: [
          BoxShadow(
            color: GNGMColors.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: GNGMColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.home_rounded,
                  color: GNGMColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'GNGM',
                style: GNGMTextStyles.brandLarge.copyWith(
                  color: GNGMColors.white,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GNGMColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: GNGMColors.white,
                    size: 20,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GNGMColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: GNGMColors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Expanded(
      flex: 7,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: GNGMColors.primaryPale,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 80,
                    color: GNGMColors.primarySubtle,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '내 주변 서비스',
                    style: GNGMTextStyles.brandLarge.copyWith(
                      color: GNGMColors.secondaryText,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '가는김에, 우리 함께',
                    style: GNGMTextStyles.brandMedium.copyWith(
                      color: GNGMColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: FloatingActionButton.small(
                onPressed: () {},
                backgroundColor: GNGMColors.white,
                child: Icon(
                  Icons.my_location,
                  color: GNGMColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: GNGMColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: GNGMColors.primarySubtle,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: GNGMColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '어디로 가시나요?',
            hintStyle: GNGMTextStyles.bodyMedium.copyWith(
              color: GNGMColors.hintText,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: GNGMColors.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: GNGMColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: CategoryItem(
              icon: Icons.shopping_cart_outlined,
              title: '장보기',
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CategoryItem(
              icon: Icons.local_shipping_outlined,
              title: '배송',
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CategoryItem(
              icon: Icons.directions_car_outlined,
              title: '이동',
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CategoryItem(
              icon: Icons.people_outline,
              title: '함께가기',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceList() {
    return Expanded(
      flex: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '내 주변 요청',
              style: GNGMTextStyles.brandMedium.copyWith(
                fontSize: 20,
                color: GNGMColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ServiceCard(
                    userName: '김지민',
                    rating: 4.8,
                    title: '홈플러스 가는김에 생필품 사다드려요',
                    location: '1.2km',
                    time: '30분 전',
                    price: '3,000원',
                    onTap: () {},
                    onContact: () {},
                  ),
                  ServiceCard(
                    userName: '박성호',
                    rating: 4.6,
                    title: '강남역 가는길에 소포 배송해드립니다',
                    location: '800m',
                    time: '1시간 전',
                    price: '5,000원',
                    onTap: () {},
                    onContact: () {},
                  ),
                  ServiceCard(
                    userName: '이서영',
                    rating: 4.9,
                    title: '약국에서 감기약 사다드릴게요',
                    location: '500m',
                    time: '2시간 전',
                    price: '2,000원',
                    onTap: () {},
                    onContact: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}