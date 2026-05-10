import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class ProfileCompleteScreen extends StatefulWidget {
  const ProfileCompleteScreen({super.key});

  @override
  State<ProfileCompleteScreen> createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _locationController = TextEditingController();
  
  bool _isLoading = false;
  String? _selectedLocation;
  double? _selectedLat;
  double? _selectedLng;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      _nicknameController.text = user.name;
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '프로필 완성',
          style: AppTextStyles.title,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                Text(
                  '거의 다 완성되었어요!',
                  style: AppTextStyles.title.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '동네와 닉네임을 설정하고\nGNGM을 시작해보세요.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // 닉네임 입력
                Text(
                  '닉네임',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _nicknameController,
                  hintText: '사용하실 닉네임을 입력해주세요',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '닉네임을 입력해주세요.';
                    }
                    if (value.trim().length < 2) {
                      return '닉네임은 2글자 이상 입력해주세요.';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // 동네 선택
                Text(
                  '동네 설정',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _showLocationPicker,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: _selectedLocation != null 
                            ? AppColors.primary 
                            : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedLocation ?? '동네를 선택해주세요',
                            style: AppTextStyles.body.copyWith(
                              color: _selectedLocation != null 
                                ? AppColors.textPrimary 
                                : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // 완료 버튼
                CustomButton(
                  text: '완료하기',
                  onPressed: _canComplete ? _completeProfile : null,
                  isLoading: _isLoading,
                  backgroundColor: AppColors.primary,
                ),
                
                const SizedBox(height: 16),
                
                // 나중에 하기 버튼
                TextButton(
                  onPressed: _skipForNow,
                  child: Text(
                    '나중에 설정할게요',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get _canComplete {
    return _nicknameController.text.trim().isNotEmpty && 
           _selectedLocation != null && 
           !_isLoading;
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationPickerBottomSheet(
        onLocationSelected: (location, lat, lng) {
          setState(() {
            _selectedLocation = location;
            _selectedLat = lat;
            _selectedLng = lng;
          });
        },
      ),
    );
  }

  Future<void> _completeProfile() async {
    if (!_formKey.currentState!.validate() || !_canComplete) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.updateProfile(
        name: _nicknameController.text.trim(),
        locationLat: _selectedLat!,
        locationLng: _selectedLng!,
      );

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? '프로필 업데이트 중 오류가 발생했습니다.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('프로필 업데이트 중 오류가 발생했습니다.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _skipForNow() {
    Navigator.pushReplacementNamed(context, '/home');
  }
}

class _LocationPickerBottomSheet extends StatelessWidget {
  final Function(String location, double lat, double lng) onLocationSelected;

  const _LocationPickerBottomSheet({
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 20),
          
          Text(
            '동네 선택',
            style: AppTextStyles.title,
          ),
          
          const SizedBox(height: 20),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildLocationItem('강남구 역삼동', 37.4980, 127.0276),
                _buildLocationItem('강남구 삼성동', 37.5119, 127.0594),
                _buildLocationItem('강남구 청담동', 37.5175, 127.0477),
                _buildLocationItem('서초구 서초동', 37.4835, 127.0324),
                _buildLocationItem('서초구 잠원동', 37.5111, 127.0112),
                _buildLocationItem('송파구 잠실동', 37.5155, 127.1012),
                _buildLocationItem('마포구 홍대입구', 37.5563, 126.9236),
                _buildLocationItem('종로구 종로3가', 37.5703, 126.9910),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(String location, double lat, double lng) {
    return Builder(
      builder: (context) {
        return ListTile(
          leading: Icon(
            Icons.location_on,
            color: AppColors.primary,
          ),
          title: Text(
            location,
            style: AppTextStyles.body,
          ),
          onTap: () {
            onLocationSelected(location, lat, lng);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}