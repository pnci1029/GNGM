import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - 소프트 민트 그린 (연한 초록 계열)
  static const Color primary = Color(0xFF66BB6A);       // 메인 브랜드 - 소프트 민트 그린
  static const Color primaryLight = Color(0xFF81C784);  // 밝은 톤 - 라이트 민트
  static const Color primaryDark = Color(0xFF4CAF50);   // 어두운 톤 - 딥 민트
  static const Color primaryPale = Color(0xFFF1F8E9);   // 연한 톤 - 페일 민트
  
  // Status Colors
  static const Color success = Color(0xFF66BB6A);       // 성공 (메인 컬러와 동일)
  static const Color warning = Color(0xFFFFB74D);       // 주의 - 소프트 오렌지
  static const Color error = Color(0xFFE57373);         // 에러 - 소프트 레드
  
  // 모바일 친화적 Neutral Colors
  static const Color white = Color(0xFFFFFFFF);         
  static const Color background = Color(0xFFF8FDF8);    // 매우 연한 민트 배경
  static const Color surface = Color(0xFFFFFFFF);       
  static const Color border = Color(0xFFE8F5E8);        // 연한 민트 보더
  
  // 모바일 가독성 Text Colors
  static const Color textPrimary = Color(0xFF2E7D32);   // 메인 텍스트 - 다크 그린
  static const Color textSecondary = Color(0xFF6C757D); // 보조 텍스트 - 그레이
  static const Color textDisabled = Color(0xFFADB5BD);  // 비활성 텍스트
  
  // 터치 인터랙션
  static const Color ripple = Color(0x1F66BB6A);        // 터치 리플 효과
  static const Color pressed = Color(0x0F66BB6A);       // 눌림 상태
  
  // 그림자 (모바일 최적화)
  static const Color shadow = Color(0x0A000000);
}