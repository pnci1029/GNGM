import 'package:flutter/material.dart';
import 'colors.dart';

class GNGMTextStyles {
  static const String fontFamily = 'Pretendard';
  
  // Text Sizes
  static const double textXL = 24.0;
  static const double textLG = 18.0;
  static const double textMD = 16.0;
  static const double textSM = 14.0;
  static const double textXS = 12.0;
  
  // Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: textXL,
    fontWeight: FontWeight.bold,
    color: GNGMColors.primaryText,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: textLG,
    fontWeight: FontWeight.w600,
    color: GNGMColors.primaryText,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: textMD,
    fontWeight: FontWeight.normal,
    color: GNGMColors.primaryText,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: textSM,
    fontWeight: FontWeight.normal,
    color: GNGMColors.secondaryText,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: textXS,
    fontWeight: FontWeight.normal,
    color: GNGMColors.hintText,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: textMD,
    fontWeight: FontWeight.w600,
    color: GNGMColors.cleanWhite,
  );
}