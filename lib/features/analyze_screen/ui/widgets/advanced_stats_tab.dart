import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/habit_keys.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/habit_constants.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';

class AdvancedStatsTab extends StatelessWidget {
  const AdvancedStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AnalyticsCubit>().state;
    final habits = context.watch<HomeCubit>().state.habits;

    if (habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('📈', style: TextStyle(fontSize: 56.sp)),
            verticalSpace(16),
            Text(
              context.l10n.noHabitsYet,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            verticalSpace(8),
            Text(
              context.l10n.addHabitsFirst,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    final totalHabits = state.totalHabits;
    final todayIndex = DateTime.now().weekday - 1;
    final completedToday = habits.where((h) {
      final progressList = h[HabitKeys.weekProgress] as List?;
      if (progressList != null && progressList.length > todayIndex) {
        return progressList[todayIndex] == true;
      }
      return false;
    }).length;

    final bestHabit = habits.reduce(
      (a, b) => ((a[HabitKeys.progress] as num?)?.toDouble() ?? 0.0) > 
                ((b[HabitKeys.progress] as num?)?.toDouble() ?? 0.0) ? a : b,
    );
    final worstHabit = habits.reduce(
      (a, b) => ((a[HabitKeys.progress] as num?)?.toDouble() ?? 0.0) < 
                ((b[HabitKeys.progress] as num?)?.toDouble() ?? 0.0) ? a : b,
    );

    final double bestProgress = (bestHabit[HabitKeys.progress] as num?)?.toDouble() ?? 0.0;
    final double worstProgress = (worstHabit[HabitKeys.progress] as num?)?.toDouble() ?? 0.0;
    final bool isProgressEqual = bestProgress == worstProgress;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.advancedStatistics,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          verticalSpace(12),
          Row(
            children: [
              _buildAdvancedCard(
                context,
                isDark,
                '$completedToday/$totalHabits',
                context.l10n.completedToday,
                Icons.check_circle,
                Colors.green,
              ),
              horizontalSpace(10),
              _buildAdvancedCard(
                context,
                isDark,
                totalHabits > 0
                    ? '${(completedToday / totalHabits * 100).toInt()}%'
                    : '0%',
                context.l10n.completionRate,
                Icons.pie_chart,
                Colors.blue,
              ),
            ],
          ),
          verticalSpace(10),
          Row(
            children: [
              _buildAdvancedCard(
                context,
                isDark,
                isProgressEqual
                    ? '${(bestProgress * 100).toInt()}%'
                    : (bestHabit[HabitKeys.title] ?? '-'),
                isProgressEqual
                    ? "Balanced Progress"
                    : context.l10n.bestPerforming,
                Icons.emoji_events,
                isProgressEqual ? Colors.blue : Colors.amber,
              ),
              horizontalSpace(10),
              _buildAdvancedCard(
                context,
                isDark,
                isProgressEqual ? "All Equal" : (worstHabit[HabitKeys.title] ?? '-'),
                isProgressEqual
                    ? "Stability Status"
                    : context.l10n.needsImprovement,
                isProgressEqual ? Icons.thumbs_up_down : Icons.warning,
                isProgressEqual ? Colors.grey : Colors.red,
              ),
            ],
          ),
          verticalSpace(20),
          Text(
            context.l10n.colorDistribution,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          verticalSpace(8),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: habits.map((habit) {
              final color = Color(habit[HabitKeys.color] ?? 0xFF2563EB);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: color),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconData(habit[HabitKeys.icon] ?? 'sport'),
                      color: color,
                      size: 14.sp,
                    ),
                    horizontalSpace(6),
                    Text(
                      habit[HabitKeys.title] ?? '',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          verticalSpace(24),
        ],
      ),
    );
  }

  Widget _buildAdvancedCard(
    BuildContext context,
    bool isDark,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16.sp),
            verticalSpace(6),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String key) {
    try {
      return HabitConstants.getIcon(key);
    } catch (_) {
      return Icons.fitness_center;
    }
  }
}