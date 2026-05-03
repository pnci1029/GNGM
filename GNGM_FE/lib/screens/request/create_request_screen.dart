import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../providers/request_provider.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  int _currentStep = 0;
  final _pageController = PageController();
  
  String? _selectedCategory;
  String _title = '';
  String _description = '';
  String _location = '';
  double _pickupLat = 37.4980;
  double _pickupLng = 127.0276;
  int _fee = 0;
  bool _isSubmitting = false;

  final _categories = [
    {'id': 'shopping', 'name': '쇼핑', 'icon': Icons.shopping_bag_outlined, 'color': AppColors.primary},
    {'id': 'delivery', 'name': '배송', 'icon': Icons.delivery_dining_outlined, 'color': AppColors.primaryLight},
    {'id': 'transport', 'name': '동행', 'icon': Icons.directions_car_outlined, 'color': AppColors.success},
    {'id': 'companion', 'name': '기타', 'icon': Icons.handshake_outlined, 'color': AppColors.warning},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildCategoryStep(),
                _buildDetailsStep(),
                _buildLocationStep(),
                _buildFeeStep(),
                _buildConfirmStep(),
              ],
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close, color: AppColors.textPrimary),
      ),
      title: Text(
        '요청 만들기',
        style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryStep() {
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
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['id'];
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['id'] as String;
                    });
                  },
                  child: Container(
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
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
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
          TextField(
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
            onChanged: (value) => _title = value,
          ),
          const SizedBox(height: 16),
          TextField(
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
            ),
            maxLines: 4,
            onChanged: (value) => _description = value,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '어디서 만날까요?',
            style: AppTextStyles.brandTitle,
          ),
          const SizedBox(height: 8),
          Text(
            '픽업 장소를 알려주세요',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _selectLocation(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('위치 선택하기'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: '상세 주소',
              hintText: '예: 스타벅스 강남역점',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
            onChanged: (value) => _location = value,
          ),
        ],
      ),
    );
  }

  Widget _buildFeeStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '감사 표현은 얼마로?',
            style: AppTextStyles.brandTitle,
          ),
          const SizedBox(height: 8),
          Text(
            '도움받을 만큼의 적당한 금액을 제안해보세요',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            decoration: InputDecoration(
              labelText: '제안 금액',
              hintText: '0',
              suffix: const Text('원'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => _fee = int.tryParse(value) ?? 0,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryPale,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 적정 금액 가이드',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• 커피 픽업: 3,000 ~ 5,000원\n• 간단한 배송: 5,000 ~ 8,000원\n• 택시 동승: 실제 요금의 50%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '요청을 확인해주세요',
            style: AppTextStyles.brandTitle,
          ),
          const SizedBox(height: 8),
          Text(
            '정보가 맞는지 확인하고 요청을 등록하세요',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getCategoryName(),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${_fee.toString()}원',
                      style: AppTextStyles.brandTitle.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _title.isEmpty ? '제목 없음' : _title,
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 8),
                Text(
                  _description.isEmpty ? '설명 없음' : _description,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _location.isEmpty ? '위치 미설정' : _location,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.border),
                  minimumSize: const Size(0, 48),
                ),
                child: const Text('이전'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _canProceed() && !_isSubmitting ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(0, 48),
              ),
              child: _isSubmitting
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : Text(
                    _currentStep == 4 ? '요청 등록하기' : '다음',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedCategory != null;
      case 1:
        return _title.isNotEmpty && _description.isNotEmpty;
      case 2:
        return _location.isNotEmpty;
      case 3:
        return _fee > 0;
      case 4:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitRequest();
    }
  }

  void _previousStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _selectLocation() {
    
  }

  String _getCategoryName() {
    if (_selectedCategory == null) return '';
    return _categories
        .firstWhere((cat) => cat['id'] == _selectedCategory)['name'] as String;
  }

  Future<void> _submitRequest() async {
    if (_selectedCategory == null || _title.isEmpty || _description.isEmpty || _location.isEmpty) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    
    final success = await requestProvider.createRequest(
      categoryType: _selectedCategory!,
      title: _title,
      description: _description,
      pickupAddress: _location,
      pickupLat: _pickupLat,
      pickupLng: _pickupLng,
      feeAmount: _fee,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('요청이 성공적으로 등록되었습니다!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(requestProvider.error ?? '요청 등록에 실패했습니다.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}