import 'package:flutter/material.dart';

class AppColors {
  // Light Theme - 모노크로매틱 코랄 핑크 톤 (Soft Coral Pink Palette)
  static const Color primary = Color(0xFFFF6F91);           // 메인 브랜드 - 코랄 핑크
  static const Color primaryLight = Color(0xFFFF8FA3);     // 밝은 톤 - 호버 상태, 강조
  static const Color primaryDark = Color(0xFFE91E63);      // 어두운 톤 - 눌림 상태, 그림자
  static const Color primaryPale = Color(0xFFFFF0F3);      // 연한 톤 - 배경, 하이라이트
  static const Color primarySubtle = Color(0xFFFFCDD2);    // 미묘한 톤 - 구분선, 보조 배경
  
  // Status Colors - 핑크 계열 기반
  static const Color success = Color(0xFFFF8FA3);          // 성공, 완료 상태 (밝은 핑크)
  static const Color successLight = Color(0xFFFFCDD2);     // 성공 배경 (연한 핑크) 
  static const Color warning = Color(0xFFFF9800);          // 주의, 대기 상태
  static const Color error = Color(0xFFF44336);            // 에러, 경고 상태
  
  // Light Theme Neutral Colors
  static const Color white = Color(0xFFFFFFFF);            // 순수 화이트
  static const Color background = Color(0xFFFAFAFA);       // 배경
  static const Color surface = Color(0xFFFFFFFF);          // 카드 배경
  static const Color border = Color(0xFFF5F5F5);           // 구분선
  static const Color gray = Color(0xFFBDBDBD);             // 비활성 요소
  static const Color secondary = Color(0xFFFF8FA3);        // 보조 컬러 (primary light와 동일)
  
  // Light Theme Text Colors
  static const Color textPrimary = Color(0xFF212121);      // 메인 텍스트
  static const Color textSecondary = Color(0xFF757575);    // 보조 텍스트
  static const Color textDisabled = Color(0xFFBDBDBD);     // 비활성 텍스트
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);    // 다크 배경
  static const Color darkSurface = Color(0xFF1E1E1E);     // 다크 카드 배경
  static const Color darkBorder = Color(0xFF2C2C2C);      // 다크 구분선
  static const Color darkGray = Color(0xFF424242);        // 다크 비활성 요소
  
  // Dark Theme Text Colors
  static const Color darkTextPrimary = Color(0xFFE0E0E0);  // 다크 메인 텍스트
  static const Color darkTextSecondary = Color(0xFFB0B0B0); // 다크 보조 텍스트
  static const Color darkTextDisabled = Color(0xFF757575); // 다크 비활성 텍스트
  
  // Dark Theme Primary (코랄 핑크 계열 유지)
  static const Color darkPrimary = Color(0xFFFF8FA3);     // 다크모드 메인 - 밝은 코랄 핑크
  static const Color darkPrimaryLight = Color(0xFFFFB3C1); // 다크모드 밝은 톤
  static const Color darkPrimaryDark = Color(0xFFFF6F91); // 다크모드 어두운 톤
  static const Color darkPrimaryPale = Color(0xFF2D1B1F);  // 다크모드 연한 배경
  static const Color darkPrimarySubtle = Color(0xFF3D2329); // 다크모드 미묘한 톤
  
  // 터치 인터랙션
  static const Color ripple = Color(0x1FFF6F91);          // 터치 리플 효과
  static const Color pressed = Color(0x0FFF6F91);         // 눌림 상태
  
  // 그림자 (모바일 최적화)
  static const Color shadow = Color(0x0A000000);
  static const Color darkShadow = Color(0x1A000000);
  
  // 블랙 (공통)
  static const Color black = Color(0xFF000000);
}