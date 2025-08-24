import 'package:flutter/material.dart';

class AppColors {
  // Primary colors from CSS
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF1A1A1A); // oklch(0.145 0 0) approximation
  
  // Custom light blue colors from CSS
  static const Color blue25 = Color(0xFFFAFBFF); // --blue-25
  static const Color blue50 = Color(0xFFEFF6FF); // --blue-50
  static const Color indigo25 = Color(0xFFFAFAFF); // --indigo-25
  static const Color indigo50 = Color(0xFFEEF2FF); // --indigo-50
  
  // Tailwind blue colors used in components
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color indigo500 = Color(0xFF6366F1);
  static const Color indigo600 = Color(0xFF4F46E5);
  
  // Gray colors
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray800 = Color(0xFF1F2937);
  
  // Other colors
  static const Color green500 = Color(0xFF10B981);
  static const Color white = Color(0xFFFFFFFF);
  
  // Border and card colors
  static const Color cardBorder = Color(0xFFDDD6FE); // border-blue-100 equivalent
  static const Color blue300 = Color(0xFF93C5FD);
}

class AppSizes {
  // Font sizes (converted from CSS --font-size: 14px base)
  static const double fontBase = 14.0;
  static const double fontSm = 12.0; // text-sm
  static const double fontLg = 18.0; // text-lg  
  static const double fontXl = 20.0; // text-xl
  static const double font2xl = 24.0; // text-2xl
  
  // Spacing (converted from Tailwind spacing scale)
  static const double spacing1 = 4.0; // space-1, p-1
  static const double spacing2 = 8.0; // space-2, p-2
  static const double spacing3 = 12.0; // space-3, p-3
  static const double spacing4 = 16.0; // space-4, p-4
  static const double spacing6 = 24.0; // space-6, p-6
  static const double spacing8 = 32.0; // space-8, p-8
  
  // Border radius (converted from CSS --radius: 0.625rem = 10px)
  static const double radiusSm = 6.0; // rounded-sm
  static const double radiusMd = 8.0; // rounded-md
  static const double radiusLg = 10.0; // rounded-lg
  static const double radiusXl = 14.0; // rounded-xl
  static const double radius2xl = 16.0; // rounded-2xl
  static const double radiusFull = 9999.0; // rounded-full
  
  // Component specific sizes
  static const double progressBarHeight = 8.0; // h-2
  static const double dayCircleSize = 32.0; // w-8 h-8
  static const double iconSize = 20.0; // w-5 h-5
  static const double iconSizeLarge = 32.0; // w-8 h-8
  static const double aiButtonSize = 192.0; // w-48 h-48
}

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: AppSizes.font2xl,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.gray800,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: AppSizes.fontLg,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.gray800,
  );
  
  static const TextStyle bodyBase = TextStyle(
    fontSize: AppSizes.fontBase,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.gray800,
  );
  
  static const TextStyle bodySm = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.gray600,
  );
  
  static const TextStyle bodySmBlue = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.blue600,
  );
  
  static const TextStyle quote = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.blue600,
    fontStyle: FontStyle.italic,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: AppSizes.fontLg,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.white,
  );


}

  bool isLoggedInUser = false;
