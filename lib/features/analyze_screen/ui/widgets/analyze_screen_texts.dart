import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';

class AnalyzeScreenTexts extends StatelessWidget {
  const AnalyzeScreenTexts({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          context.l10n.aiAnalysis,
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        verticalSpace(16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            context.l10n.analyzeScreenSubtitle,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              height: 1.5.h,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
