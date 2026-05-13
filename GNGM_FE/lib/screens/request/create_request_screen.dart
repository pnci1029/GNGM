import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../providers/request_provider.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _feeController = TextEditingController();
  
  String? _selectedCategory;
  bool _isSubmitting = false;

  final _categories = [
    {'id': 'shopping', 'name': '쇼핑', 'color': AppColors.primary},
    {'id': 'delivery', 'name': '배송', 'color': AppColors.primaryLight},
    {'id': 'transport', 'name': '동행', 'color': AppColors.primaryDark},
    {'id': 'companion', 'name': '기타', 'color': AppColors.primaryLight},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('요청 만들기'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('어떤 도움이 필요하신가요?'),
              const SizedBox(height: 12),
              _buildCategorySelector(),
              
              const SizedBox(height: 32),
              _buildSectionTitle('요청 내용'),
              const SizedBox(height: 12),
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              
              const SizedBox(height: 32),
              _buildSectionTitle('만날 장소'),
              const SizedBox(height: 12),
              _buildLocationField(),
              
              const SizedBox(height: 32),
              _buildSectionTitle('제안 금액'),
              const SizedBox(height: 12),
              _buildFeeField(),
              
              const SizedBox(height: 40),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.doHyeon(
        fontSize: 20,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCategorySelector() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 2,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Center(
              child: Text(
                category['name'] as String,
                style: GoogleFonts.doHyeon(
                  fontSize: 14,
                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: GoogleFonts.doHyeon(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: '제목',
        hintText: '예: 스타벅스 아메리카노 픽업',
        prefixIcon: const Icon(Icons.title, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.white,
        labelStyle: GoogleFonts.doHyeon(
          color: AppColors.textSecondary,
        ),
        hintStyle: GoogleFonts.doHyeon(
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '제목을 입력해주세요';
        }
        if (value.trim().length < 5) {
          return '제목은 5글자 이상 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      style: GoogleFonts.doHyeon(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: '상세 내용',
        hintText: '어떤 도움이 필요한지 구체적으로 설명해주세요',
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 60),
          child: Icon(Icons.description, color: AppColors.textSecondary),
        ),
        filled: true,
        fillColor: AppColors.white,
        labelStyle: GoogleFonts.doHyeon(
          color: AppColors.textSecondary,
        ),
        hintStyle: GoogleFonts.doHyeon(
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '상세 내용을 입력해주세요';
        }
        if (value.trim().length < 10) {
          return '상세 내용은 10글자 이상 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget _buildLocationField() {
    return Column(
      children: [
        TextFormField(
          controller: _locationController,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: '만날 장소',
            hintText: '예: 강남역 2번 출구',
            prefixIcon: const Icon(Icons.location_on, color: AppColors.textSecondary),
            suffixIcon: IconButton(
              icon: const Icon(Icons.map, color: AppColors.textSecondary),
              onPressed: () {
                // TODO: 지도에서 위치 선택 기능
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('지도 기능은 추후 구현 예정입니다')),
                );
              },
            ),
            filled: true,
            fillColor: AppColors.white,
            labelStyle: const TextStyle(color: AppColors.textSecondary),
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '만날 장소를 입력해주세요';
            }
            if (value.trim().length < 5) {
              return '만날 장소는 5글자 이상 입력해주세요';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          '정확한 위치를 입력하면 더 빠른 매칭이 가능해요',
          style: GoogleFonts.doHyeon(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFeeField() {
    return Column(
      children: [
        TextFormField(
          controller: _feeController,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: '제안 금액',
            hintText: '10000',
            suffixText: '원',
            suffixStyle: GoogleFonts.doHyeon(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
            filled: true,
            fillColor: AppColors.white,
            labelStyle: const TextStyle(color: AppColors.textSecondary),
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '제안 금액을 입력해주세요';
            }
            final fee = int.tryParse(value);
            if (fee == null || fee <= 0) {
              return '올바른 금액을 입력해주세요';
            }
            if (fee < 1000) {
              return '최소 금액은 1,000원입니다';
            }
            if (fee > 100000) {
              return '제안 금액은 10만원을 초과할 수 없습니다';
            }
            return null;
          },
        ),
      ],
    );
  }


  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                '요청 등록하기',
                style: GoogleFonts.doHyeon(
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('카테고리를 선택해주세요'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    
    final success = await requestProvider.createRequest(
      categoryType: _selectedCategory!,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      pickupAddress: _locationController.text.trim(),
      pickupLat: 37.4980, // TODO: 실제 위치로 교체
      pickupLng: 127.0276, // TODO: 실제 위치로 교체
      feeAmount: int.parse(_feeController.text),
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