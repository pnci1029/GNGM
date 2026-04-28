import 'package:flutter/material.dart';

class GNGMColors {
  // Primary Colors (Ultra Soft Mint Green - 30% more white)
  static const Color primary = Color(0xFF81C784);       // 메인 브랜드 (매우 연한 그린)
  static const Color primaryLight = Color(0xFFA5D6A7);  // 밝은 톤
  static const Color primaryDark = Color(0xFF66BB6A);   // 어두운 톤 (기존 light)
  static const Color primaryPale = Color(0xFFF8FDF8);   // 매우 연한 톤 (거의 흰색)
  static const Color primarySubtle = Color(0xFFE8F5E8); // 미묘한 톤 (더 연하게)
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);       // 성공
  static const Color warning = Color(0xFFFF9800);       // 주의
  static const Color error = Color(0xFFF44336);         // 에러
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);         // 순수 화이트
  static const Color gray50 = Color(0xFFFAFAFA);        // 카드 배경
  static const Color gray100 = Color(0xFFF5F5F5);       // 구분선
  static const Color gray400 = Color(0xFFBDBDBD);       // 비활성 텍스트
  static const Color gray600 = Color(0xFF757575);       // 보조 텍스트
  static const Color gray900 = Color(0xFF212121);       // 메인 텍스트
  
  // Legacy Support (for easy migration)
  static const Color backgroundColor = white;
  static const Color cardBackground = gray50;
  static const Color surfaceColor = primaryPale;
  static const Color primaryText = gray900;
  static const Color secondaryText = gray600;
  static const Color hintText = gray400;
}