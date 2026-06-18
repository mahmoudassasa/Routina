import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';

class HabitTrackerScreenHeader extends StatelessWidget {
  const HabitTrackerScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: Row(
          children: [
            // Decorative Icon Container
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24.r),
                border: isDark
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      )
                    : null,
              ),
              child:  Center(
                child: Text('📊', style: TextStyle(fontSize: 24.sp)),
              ),
            ),

            horizontalSpace(16),

            // Header Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.habitTracker,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                verticalSpace(2),
                Text(
                  context.l10n.habitTrackerDesc,
                  style: TextStyle(
                    fontSize: 14.sp, // Slightly smaller for better hierarchy
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
