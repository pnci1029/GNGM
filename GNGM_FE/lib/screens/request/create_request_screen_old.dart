import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../providers/request_provider.dart';
import '../../widgets/create_request/category_step.dart';
import '../../widgets/create_request/details_step.dart';
import '../../widgets/create_request/location_step.dart';
import '../../widgets/create_request/fee_step.dart';
import '../../widgets/create_request/confirm_step.dart';
import '../../widgets/create_request/create_request_progress.dart';
import '../../widgets/create_request/create_request_actions.dart';

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
    {'id': 'shopping', 'name': '쇼핑'},
    {'id': 'delivery', 'name': '배송'},
    {'id': 'transport', 'name': '동행'},
    {'id': 'companion', 'name': '기타'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          CreateRequestProgress(
            currentStep: _currentStep,
            totalSteps: 5,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                CategoryStep(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
                DetailsStep(
                  title: _title,
                  description: _description,
                  onTitleChanged: (value) => setState(() => _title = value),
                  onDescriptionChanged: (value) => setState(() => _description = value),
                ),
                LocationStep(
                  location: _location,
                  onLocationChanged: (value) => setState(() => _location = value),
                  onSelectLocation: _selectLocation,
                ),
                FeeStep(
                  fee: _fee,
                  onFeeChanged: (value) => setState(() => _fee = int.tryParse(value) ?? 0),
                ),
                ConfirmStep(
                  selectedCategory: _selectedCategory,
                  title: _title,
                  description: _description,
                  location: _location,
                  fee: _fee,
                  getCategoryName: _getCategoryName,
                ),
              ],
            ),
          ),
          CreateRequestActions(
            currentStep: _currentStep,
            totalSteps: 5,
            isSubmitting: _isSubmitting,
            canProceed: _canProceed(),
            onPrevious: _previousStep,
            onNext: _nextStep,
          ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('지도 연동 기능은 추후 구현 예정입니다')),
    );
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
        const SnackBar(
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