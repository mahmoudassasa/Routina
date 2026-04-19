import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class PasswordValidations extends StatelessWidget {
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasSpecialCharacters;
  final bool hasNumber;
  final bool hasMinLength;

  const PasswordValidations({
    super.key,
    required this.hasUpperCase,
    required this.hasLowerCase,
    required this.hasSpecialCharacters,
    required this.hasNumber,
    required this.hasMinLength,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildValidationRow("At least 1 lowercase letter", hasLowerCase, isDark),
        verticalSpace(8),
        _buildValidationRow("At least 1 uppercase letter", hasUpperCase, isDark),
        verticalSpace(8),
        _buildValidationRow("At least 1 special character", hasSpecialCharacters, isDark),
        verticalSpace(8),
        _buildValidationRow("At least 1 number", hasNumber, isDark),
        verticalSpace(8),
        _buildValidationRow("At least 8 characters", hasMinLength, isDark),
      ],
    );
  }

  Widget _buildValidationRow(String text, bool isValid, bool isDark) {
    // Brand-consistent colors matching your button and logo
    final Color activeColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final Color inactiveColor = isDark ? Colors.white24 : Colors.grey.shade400;

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: AppTextStyles.bodySmall.copyWith(
        color: isValid ? (isDark ? Colors.white : AppColors.textPrimary) : inactiveColor,
        fontWeight: isValid ? FontWeight.w600 : FontWeight.normal,
      ),
      child: Row(
        children: [
          // Dynamic Icon/Dot based on validation state
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isValid ? activeColor.withValues(alpha:  0.1) : Colors.transparent,
            ),
            child: Icon(
              isValid ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 16.sp,
              color: isValid ? activeColor : inactiveColor,
            ),
          ),
          horizontalSpace(10),
          Text(text),
        ],
      ),
    );
  }
}