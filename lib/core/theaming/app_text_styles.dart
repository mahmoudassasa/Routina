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
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
    height: 1.3,
    inherit: true,
  );

  // ... Keep the rest of your class
  // Display Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    inherit: true,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    inherit: true,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
    inherit: true,
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
    inherit: true,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
    inherit: true,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    inherit: true,
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    inherit: true,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
    inherit: true,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
    inherit: true,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
    inherit: true,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
    inherit: true,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
    inherit: true,
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
    inherit: true,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
    inherit: true,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
    inherit: true,
  );

  // Button Styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    height: 1.2,
    inherit: true,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    height: 1.2,
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
