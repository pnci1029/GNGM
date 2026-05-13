import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  // Brand title (큰 브랜드 제목)
  static TextStyle get brandTitle => GoogleFonts.doHyeon(
    fontSize: 28,
    color: AppColors.primary,
  );

  // Main title (제목)
  static TextStyle get title => GoogleFonts.doHyeon(
    fontSize: 20,
    color: AppColors.textPrimary,
  );

  // Subtitle (부제목)
  static TextStyle get subtitle => GoogleFonts.doHyeon(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  // Body text (본문)
  static TextStyle get body => GoogleFonts.doHyeon(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  // Small body text (작은 본문)
  static TextStyle get bodySmall => GoogleFonts.doHyeon(
    fontSize: 12,
    color: AppColors.textPrimary,
  );

  // Caption (캡션)
  static TextStyle get caption => GoogleFonts.doHyeon(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  // Button text
  static TextStyle get button => GoogleFonts.doHyeon(
    fontSize: 16,
    color: AppColors.white,
  );
}