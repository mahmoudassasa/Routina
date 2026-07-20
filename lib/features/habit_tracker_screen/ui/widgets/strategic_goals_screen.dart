import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';

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
            context.l10n.strategicGoals,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: _buildBody(context, isDark),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isDark) {
    if (habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎯', style: TextStyle(fontSize: 56.sp)),
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

    final consistencyScore = _calculateConsistencyScore(habits);
    final priorityHabitTitles = _getPriorityHabits(habits);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ConsistencyScoreCard(score: consistencyScore, isDark: isDark),
          verticalSpace(20),
          Text(
            context.l10n.milestoneProgress,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          verticalSpace(10),
          ...habits.map((habit) {
            final isPriority = priorityHabitTitles.contains(habit['title']);
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _HabitGoalCard(
                habit: habit,
                isPriority: isPriority,
                isDark: isDark,
              ),
            );
          }),
          verticalSpace(24),
        ],
      ),
    );
  }

  // Consistency Score: percentage of completed days across all habits,
  // out of all possible days tracked so far (based on weekProgress).
  // Pure local arithmetic — no AI, no network call.
  double _calculateConsistencyScore(List<Map<String, dynamic>> habits) {
    int totalCompleted = 0;
    int totalPossible = 0;

    for (final habit in habits) {
      final weekProgress = habit['weekProgress'] as List?;
      if (weekProgress == null) continue;
      for (final day in weekProgress) {
        totalPossible++;
        if (day == true) totalCompleted++;
      }
    }

    if (totalPossible == 0) return 0.0;
    return (totalCompleted / totalPossible) * 100;
  }

  // Flags the bottom ~30% of habits by progress as needing attention.
  // Same comparative logic already used in _AdvancedStatsTab's
  // worstHabit calculation, just applied across the full list instead
  // of picking a single minimum.
  List<String> _getPriorityHabits(List<Map<String, dynamic>> habits) {
    if (habits.length <= 1) return [];

    final sorted = List<Map<String, dynamic>>.from(habits)
      ..sort((a, b) =>
          (a['progress'] ?? 0.0).compareTo(b['progress'] ?? 0.0));

    final priorityCount = (habits.length * 0.3).ceil().clamp(1, habits.length);
    return sorted
        .take(priorityCount)
        .map((h) => h['title'] as String? ?? '')
        .toList();
  }
}

class _ConsistencyScoreCard extends StatelessWidget {
  final double score;
  final bool isDark;

  const _ConsistencyScoreCard({required this.score, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = score >= 70
        ? Colors.green
        : score >= 40
            ? Colors.orange
            : Colors.red;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: color, size: 22.sp),
              horizontalSpace(8),
              Text(
                context.l10n.consistencyScore,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${score.toInt()}%',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          verticalSpace(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: (score / 100).clamp(0.0, 1.0),
              minHeight: 8.h,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitGoalCard extends StatelessWidget {
  final Map<String, dynamic> habit;
  final bool isPriority;
  final bool isDark;

  const _HabitGoalCard({
    required this.habit,
    required this.isPriority,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final title = habit['title'] as String? ?? '';
    final weekProgress = (habit['weekProgress'] as List?) ?? [];
    final completedDays = weekProgress.where((d) => d == true).length;
    final totalDays = weekProgress.length;
    final progress = (habit['progress'] ?? 0.0) as double;
    final streak = (habit['streak'] ?? 0) as int;

    // Simple linear projection: at the current weekly completion rate,
    // estimate weeks remaining to reach 100% monthly consistency.
    // This is arithmetic, not a forecast model — intentionally simple
    // and transparent about what it's showing.
    final weeklyRate = totalDays > 0 ? completedDays / totalDays : 0.0;
    final String projectionText;
    if (weeklyRate >= 1.0) {
      projectionText = context.l10n.goalOnTrack;
    } else if (weeklyRate <= 0.0) {
      projectionText = context.l10n.goalNeedsStart;
    } else {
      final weeksToGoal = ((1.0 - progress) / weeklyRate).ceil().clamp(1, 52);
      projectionText = context.l10n.goalProjection(weeksToGoal);
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isPriority
              ? Colors.orange.withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : Colors.grey.shade200),
          width: isPriority ? 1.5.w : 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              if (isPriority)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    context.l10n.needsFocus,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
          verticalSpace(10),
          Row(
            children: [
              Icon(Icons.check_circle_outline, size: 14.sp, color: AppColors.primary),
              horizontalSpace(6),
              Text(
                '$completedDays/$totalDays ${context.l10n.thisWeek}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              horizontalSpace(12),
              Icon(Icons.local_fire_department, size: 14.sp, color: Colors.orange),
              horizontalSpace(4),
              Text(
                '$streak',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          verticalSpace(8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 6.h,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          verticalSpace(8),
          Text(
            projectionText,
            style: TextStyle(
              fontSize: 11.sp,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}