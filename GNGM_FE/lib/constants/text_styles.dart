import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class GNGMTextStyles {
  // Font Families - 3가지 샘플
  static const String fontDoHyeon = 'Do Hyeon';                   // 도현체 (모던하고 친근함)
  static const String fontJua = 'Jua';                           // 주아체 (둥글고 귀여움)  
  static const String fontSunflower = 'Sunflower';               // 해바라기체 (깔끔하고 모던)
  static const String fontFamilyBase = 'Noto Sans KR';           // 노토 산스 (본문용)
  
  // Text Sizes
  static const double textBrand = 28.0;  // 브랜드 로고, 타이틀
  static const double textXL = 24.0;     // 주요 제목
  static const double textLG = 18.0;     // 서브타이틀
  static const double textMD = 16.0;     // 본문
  static const double textSM = 14.0;     // 보조 정보
  static const double textXS = 12.0;     // 캡션
  
  // Brand Styles - 3가지 샘플 (Google Fonts 사용)
  static TextStyle brandLarge1 = GoogleFonts.doHyeon(
    fontSize: textBrand,
    fontWeight: FontWeight.normal,
    color: GNGMColors.primary,
  );
  
  static TextStyle brandLarge2 = GoogleFonts.jua(
    fontSize: textBrand,
    fontWeight: FontWeight.normal,
    color: GNGMColors.primary,
  );
  
  static TextStyle brandLarge3 = GoogleFonts.sunflower(
    fontSize: textBrand,
    fontWeight: FontWeight.w500,
    color: GNGMColors.primary,
  );
  
  // 현재 적용중 (주아체)
  static TextStyle brandLarge = brandLarge2;
  static TextStyle brandMedium = GoogleFonts.jua(
    fontSize: textLG,
    fontWeight: FontWeight.normal,
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