import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/feature_preview_card.dart';

class HabitTrackerScreenComingSoonContent extends StatelessWidget {
  const HabitTrackerScreenComingSoonContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                      blurRadius: 20.r,
                      offset: Offset(0, 8.h),
                    ),
                  ],
                  border: isDark 
                      ? Border.all(color: AppColors.darkBorder, width: 1.w)
                      : null,
                ),
                child: Center(
                  child: Text('🚧', style: TextStyle(fontSize: 48.sp)),
                ),
              ),

              SizedBox(height: 24.h),

              Text(
                'Coming Soon!',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 16.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  'Advanced habit tracking features including charts, statistics, and detailed analytics will be available here.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 32.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  children: const [
                    FeaturePreviewCard(
                      icon: '📈',
                      title: 'Progress Charts',
                      description: 'Visual progress tracking over time',
                    ),
                    SizedBox(height: 12),
                    FeaturePreviewCard(
                      icon: '🎯',
                      title: 'Goal Setting',
                      description: 'Set and track specific habit goals',
                    ),
                    SizedBox(height: 12),
                    FeaturePreviewCard(
                      icon: '🏆',
                      title: 'Achievements',
                      description: 'Unlock badges and milestones',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}