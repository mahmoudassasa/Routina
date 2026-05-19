import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/habit_constants.dart';

class PremiumAnalyticsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> habits;
  const PremiumAnalyticsScreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Compute analytics
    final sorted = [...habits]
      ..sort(
        (a, b) =>
            (b['streak'] as int? ?? 0).compareTo(a['streak'] as int? ?? 0),
      );
    final best = sorted.isNotEmpty ? sorted.first : null;
    final worst = sorted.length > 1 ? sorted.last : null;

    final avgCompletion = habits.isEmpty
        ? 0.0
        : habits.fold<double>(
                0,
                (sum, h) => sum + (h['progress'] as double? ?? 0.0),
              ) /
              habits.length;

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
            context.l10n.eliteInsights,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary cards row
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      isDark: isDark,
label: context.l10n.avgCompletion,                      value: '${(avgCompletion * 100).toInt()}%',
                      icon: '📊',
                      color: AppColors.primary,
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: _MetricCard(
                      isDark: isDark,
label: context.l10n.totalHabits,                      value: '${habits.length}',
                      icon: '📋',
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              verticalSpace(12),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      isDark: isDark,
label: context.l10n.bestStreak,                      value: '${best?['streak'] ?? 0}d',
                      icon: '🔥',
                      color: Colors.orange,
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: _MetricCard(
                      isDark: isDark,
label: context.l10n.needsFocus,                      value: worst?['title'] as String? ?? '-',
                      icon: '⚡',
                      color: Colors.redAccent,
                      small: true,
                    ),
                  ),
                ],
              ),
              verticalSpace(24),

              // Best habit
              if (best != null) ...[
                _SectionTitle(title: context.l10n.bestPerforming, isDark: isDark),
                verticalSpace(12),
                _HabitInsightCard(habit: best, isDark: isDark, highlight: true),
                verticalSpace(24),
              ],

              // All habits breakdown
              _SectionTitle(title: context.l10n.completionBreakdown, isDark: isDark),
              verticalSpace(12),
              ...habits.map(
                (habit) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _CompletionBar(habit: habit, isDark: isDark),
                ),
              ),

              verticalSpace(24),

              // Priority focus
              _SectionTitle(title: context.l10n.priorityFocus, isDark: isDark),
              verticalSpace(12),
              Container(
                width: double.infinity,
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
                    ...habits
                        .where((h) => (h['progress'] as double? ?? 0) < 0.5)
                        .map(
                          (h) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.amber,
                                  size: 16.sp,
                                ),
                                horizontalSpace(8),
                                Expanded(
                                  child: Text(
                                    h['title'] as String,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${((h['progress'] as double? ?? 0) * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    if (habits.every(
                      (h) => (h['progress'] as double? ?? 0) >= 0.5,
                    ))
                      Center(
                        child: Text(
                          context.l10n.allHabitsOnTrack,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              verticalSpace(40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final bool isDark;
  final String label;
  final String value;
  final String icon;
  final Color color;
  final bool small;

  const _MetricCard({
    required this.isDark,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: TextStyle(fontSize: 20.sp)),
          verticalSpace(8),
          Text(
            value,
            style: TextStyle(
              fontSize: small ? 13.sp : 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          verticalSpace(4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitInsightCard extends StatelessWidget {
  final Map<String, dynamic> habit;
  final bool isDark;
  final bool highlight;

  const _HabitInsightCard({
    required this.habit,
    required this.isDark,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = habit['progress'] as double? ?? 0.0;
    final streak = habit['streak'] as int? ?? 0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primary.withValues(alpha: 0.1)
            : isDark
            ? AppColors.darkSurface
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: highlight
              ? AppColors.primary.withValues(alpha: 0.4)
              : isDark
              ? AppColors.darkBorder
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            HabitConstants.getIcon(habit['icon'] as String? ?? ''),
            color: Color(habit['color'] as int? ?? 0xFF2563EB),
            size: 28.sp,
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit['title'] as String,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                verticalSpace(4),
                Text(
                  context.l10n.dayStreak(streak.toString(), (progress * 100).toInt().toString()),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionBar extends StatelessWidget {
  final Map<String, dynamic> habit;
  final bool isDark;

  const _CompletionBar({required this.habit, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final progress = habit['progress'] as double? ?? 0.0;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            HabitConstants.getIcon(habit['icon'] as String? ?? ''),
            color: Color(habit['color'] as int? ?? 0xFF2563EB),
            size: 18.sp,
          ),

          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit['title'] as String,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                verticalSpace(6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6.h,
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceLight
                        : Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(
                      progress >= 0.7
                          ? AppColors.primary
                          : progress >= 0.4
                          ? Colors.amber
                          : Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(10),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
