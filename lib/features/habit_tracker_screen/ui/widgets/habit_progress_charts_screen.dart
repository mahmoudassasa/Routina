import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';

part 'section_title.dart';
part 'weekly_heatmap.dart';
part 'metric_card.dart';
part 'habit_progress_line.dart';
part 'insight_box.dart';
part 'empty_state.dart';

class HabitProgressChartsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> habits;

  const HabitProgressChartsScreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. Calculate Average Progress
    double avgCompletion = habits.isEmpty
        ? 0
        : habits
                .map((h) => (h['progress'] as num).toDouble())
                .reduce((a, b) => a + b) /
            habits.length;

    // 2. Calculate Total Streaks
    int totalStreaks = habits.isEmpty
        ? 0
        : habits
            .map((h) => (h['streak'] as int? ?? 0))
            .reduce((a, b) => a + b);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF13151A) : const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(
context.l10n.habitAnalytics,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp),
          onPressed: () => context.pop(),
        ),
      ),
      body: habits.isEmpty
          ? _buildEmptyState(isDark, context)
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(isDark, context.l10n.weeklyActivity),
                  verticalSpace(12), 
                  _buildWeeklyHeatmap(isDark, habits, context),
                  verticalSpace(24), 
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          isDark,
                          context.l10n.avgProgress,
                          '${(avgCompletion * 100).toInt()}%',
                          Icons.donut_large,
                          Colors.blueAccent,
                        ),
                      ),
                      horizontalSpace(12),
                      Expanded(
                        child: _buildMetricCard(
                          isDark,
                          context.l10n.totalStreaks,
                          context.l10n.totalStreaksDays(totalStreaks),
                          Icons.local_fire_department,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(24), 
                  _buildSectionTitle(isDark, context.l10n.individualPerformance),
                  verticalSpace(12), 
                  ...habits.map((habit) {
                    return _buildHabitProgressLine(
                      isDark,
                      habit['title'] ?? 'Habit',
                      (habit['progress'] as num).toDouble(),
                      Color(habit['color'] as int),
                    );
                  }),
                  verticalSpace(32), 
                  _buildInsightBox(isDark, avgCompletion,context),
                  verticalSpace(24), 
                ],
              ),
            ),
    );
  }

}