import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';

class RegisterScreenBirthDateField extends StatelessWidget {
  final TextEditingController dobController;
  final VoidCallback onTap;

  const RegisterScreenBirthDateField({
    super.key,
    required this.dobController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final defaultFillColor = isDark ? AppColors.darkBackgroundLight : AppColors.backgroundLight;

    return TextFormField(
      controller: dobController,
      readOnly: true,
      onTap: onTap,
      style: TextStyle(
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        labelText: '${context.l10n.birthDatePlaceholder} (${context.l10n.optional})',
        labelStyle: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          fontSize: 14.sp,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        fillColor: defaultFillColor,
        filled: true,
        prefixIcon: Icon(
          Icons.calendar_month_outlined,
          color: isDark ? AppColors.primaryLight : AppColors.primary,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.error, width: 1.5.w),
        ),
      ),
      validator: (value) => null,
    );
  }
}