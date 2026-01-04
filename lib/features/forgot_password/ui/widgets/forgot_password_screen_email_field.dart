import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';

class ForgotPasswordScreenEmailField extends StatelessWidget {
  final TextEditingController _emailController;
  
  const ForgotPasswordScreenEmailField({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: isDark ? Colors.white : AppColors.textPrimary,
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        hintText: 'Email Address',
        hintStyle: TextStyle(
          color: isDark ? Colors.white54 : AppColors.textSecondary,
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: isDark ? AppColors.primaryLight : AppColors.primary,
          size: 20.sp,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.white.withValues(alpha: 0.9),
        
        // Custom Rounded Borders to match your theme
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
      ),
    );
  }
}