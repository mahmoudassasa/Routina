import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SkipButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            // Use primaryLight for dark mode visibility
            foregroundColor: isDark
                ? AppColors.primaryLight
                : AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          child: Text(
            context.l10n.skip,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              // Fallback color if primaryLight isn't white enough
              color: isDark ? Colors.white70 : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
