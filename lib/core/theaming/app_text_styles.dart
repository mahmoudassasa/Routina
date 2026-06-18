import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle font24BlackBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
  static TextStyle font14GrayRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  static TextStyle font18WhiteExtraBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 1.2,
  );
  static TextStyle headlineMediumAccent = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
    height: 1.3.h,
    inherit: true,
  );

  // Display Styles
  static TextStyle displayLarge = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2.h,
    inherit: true,
  );

  static TextStyle displayMedium = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2.h,
    inherit: true,
  );

  static TextStyle displaySmall = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3.h,
    inherit: true,
  );

  // Headline Styles
  static TextStyle headlineLarge = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3.h,
    inherit: true,
  );

  static TextStyle headlineMedium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3.h,
    inherit: true,
  );

  static TextStyle headlineSmall = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4.h,
    inherit: true,
  );

  // Title Styles
  static TextStyle titleLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4.h,
    inherit: true,
  );

  static TextStyle titleMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4.h,
    inherit: true,
  );

  static TextStyle titleSmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4.h,
    inherit: true,
  );

  // Body Styles
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5.h,
    inherit: true,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5.h,
    inherit: true,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5.h,
    inherit: true,
  );

  // Label Styles
  static TextStyle labelLarge = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4.h,
    inherit: true,
  );

  static TextStyle labelMedium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4.h,
    inherit: true,
  );

  static TextStyle labelSmall = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4.h,
    inherit: true,
  );

  // Button Styles
  static TextStyle buttonLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    height: 1.2.h,
    inherit: true,
  );

  static TextStyle buttonMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    height: 1.2.h,
    inherit: true,
  );

  // White Styles (used in Paywall & Premium screens)
  static TextStyle font14WhiteRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
  static TextStyle font24WhiteBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle font16WhiteMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle font12WhiteRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
}
