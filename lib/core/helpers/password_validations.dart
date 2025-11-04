import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildValidationRow("At least 1 lowercase letter", hasLowerCase),
        SizedBox(height: 4.h),
        _buildValidationRow("At least 1 uppercase letter", hasUpperCase),
        SizedBox(height: 4.h),
        _buildValidationRow("At least 1 special character", hasSpecialCharacters),
        SizedBox(height: 4.h),
        _buildValidationRow("At least 1 number", hasNumber),
        SizedBox(height: 4.h),
        _buildValidationRow("At least 8 characters", hasMinLength),
      ],
    );
  }

  Widget _buildValidationRow(String text, bool isValid) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isValid ? AppColors.success : AppColors.textLight,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(
            color: isValid ? AppColors.success : AppColors.textSecondary,
            decoration: isValid ? TextDecoration.lineThrough : TextDecoration.none,
            decorationColor: AppColors.success,
            decorationThickness: 2,
          ),
        ),
      ],
    );
  }
}
