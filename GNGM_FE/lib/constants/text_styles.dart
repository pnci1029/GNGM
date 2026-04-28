import 'package:flutter/material.dart';
import 'colors.dart';

class GNGMTextStyles {
  // Font Families
  static const String fontFamilySignature = 'Gamja Flower';       // 감자꽃 (구글 폰트, 귀여운 손글씨)
  static const String fontFamilyBase = 'Noto Sans KR';            // 노토 산스 (구글 폰트)
  
  // Text Sizes
  static const double textBrand = 28.0;  // 브랜드 로고, 타이틀
  static const double textXL = 24.0;     // 주요 제목
  static const double textLG = 18.0;     // 서브타이틀
  static const double textMD = 16.0;     // 본문
  static const double textSM = 14.0;     // 보조 정보
  static const double textXS = 12.0;     // 캡션
  
  // Brand Styles (HyangSoo)
  static const TextStyle brandLarge = TextStyle(
    fontFamily: fontFamilySignature,
    fontSize: textBrand,
    fontWeight: FontWeight.bold,
    color: GNGMColors.primary,
  );
  
  static const TextStyle brandMedium = TextStyle(
    fontFamily: fontFamilySignature,
    fontSize: textLG,
    fontWeight: FontWeight.w600,
    color: GNGMColors.primary,
  );
  
  // Headline Styles (Pretendard)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamilyBase,
    fontSize: textXL,
    fontWeight: FontWeight.bold,
    color: GNGMColors.primaryText,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamilyBase,
    fontSize: textLG,
    fontWeight: FontWeight.w600,
    color: GNGMColors.primaryText,
  );
  
  // Body Styles (Pretendard)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyBase,
    fontSize: textMD,
    fontWeight: FontWeight.normal,
    color: GNGMColors.primaryText,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyBase,
    fontSize: textSM,
    fontWeight: FontWeight.normal,
    color: GNGMColors.secondaryText,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyBase,
    fontSize: textXS,
    fontWeight: FontWeight.normal,
    color: GNGMColors.hintText,
  );
  
  // Button Styles
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamilyBase,
    fontSize: textMD,
    fontWeight: FontWeight.w600,
    color: GNGMColors.white,
  );
  
  static const TextStyle buttonTextPrimary = TextStyle(
    fontFamily: fontFamilyBase,
    fontSize: textMD,
    fontWeight: FontWeight.w600,
    color: GNGMColors.white,
  );
  
  static const TextStyle buttonTextSecondary = TextStyle(
    fontFamily: fontFamilyBase,
    fontSize: textMD,
    fontWeight: FontWeight.w600,
    color: GNGMColors.primary,
  );
}