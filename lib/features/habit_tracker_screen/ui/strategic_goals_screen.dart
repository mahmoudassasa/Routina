import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/habit_constants.dart';

class StrategicGoalsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> habits;
  const StrategicGoalsScreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkBackgroundGradientStart,
                  AppColors.darkBackgroundGradientEnd,
                ]
              : [
                  AppColors.backgroundGradientStart,
                  AppColors.backgroundGradientEnd,
                ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          title: Text(
            'Strategic Goals',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: habits.isEmpty
            ? _buildEmpty(isDark)
            : _buildContent(context, isDark),
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🎯', style: TextStyle(fontSize: 64.sp)),
          verticalSpace(16),
          Text(
            'No habits yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          verticalSpace(8),
          Text(
            'Add habits first to set strategic goals',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return ListView.separated(
      padding: EdgeInsets.all(20.w),
      itemCount: habits.length,
      separatorBuilder: (_, __) => verticalSpace(12),
      itemBuilder: (context, index) {
        final habit = habits[index];
        final title = habit['title'] as String;
        final streak = habit['streak'] as int? ?? 0;

        // Milestones: 7, 21, 66 days
        final milestones = [7, 21, 66];
        final currentMilestone = milestones.firstWhere(
          (m) => streak < m,
          orElse: () => 66,
        );
        final milestoneProgress = (streak / currentMilestone).clamp(0.0, 1.0);

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    HabitConstants.getIcon(habit['icon'] as String? ?? ''),
                    color: Color(habit['color'] as int? ?? 0xFF2563EB),
                    size: 24.sp,
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '🔥 $streak days',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(16),

              // Milestone progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next milestone: $currentMilestone days',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${(milestoneProgress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              verticalSpace(8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: milestoneProgress,
                  minHeight: 8.h,
                  backgroundColor: isDark
                      ? AppColors.darkSurfaceLight
                      : Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              verticalSpace(12),

              // Milestones row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: milestones.map((m) {
                  final achieved = streak >= m;
                  return Column(
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: achieved
                              ? AppColors.primary
                              : isDark
                              ? AppColors.darkSurfaceLight
                              : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            achieved ? '✓' : '$m',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: achieved
                                  ? Colors.white
                                  : isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(4),
                      Text(
                        '${m}d',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
