import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.height = 56,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null && !isLoading 
            ? backgroundColor 
            : backgroundColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          elevation: 0,
          padding: padding,
        ),
        child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            )
          : Text(
              text,
              style: AppTextStyles.button.copyWith(
                color: textColor,
              ),
            ),
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color borderColor;
  final Color textColor;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const CustomOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.borderColor = AppColors.primary,
    this.textColor = AppColors.primary,
    this.height = 56,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: onPressed != null && !isLoading 
              ? borderColor 
              : borderColor.withOpacity(0.5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          padding: padding,
        ),
        child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            )
          : Text(
              text,
              style: AppTextStyles.button.copyWith(
                color: textColor,
              ),
            ),
      ),
    );
  }
}