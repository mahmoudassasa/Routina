import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';

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
          'Habit Analytics',
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
          ? _buildEmptyState(isDark)
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(isDark, 'Weekly Activity'),
                  verticalSpace(12), 
                  _buildWeeklyHeatmap(isDark, habits),
                  verticalSpace(24), 
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          isDark,
                          'Avg. Progress',
                          '${(avgCompletion * 100).toInt()}%',
                          Icons.donut_large,
                          Colors.blueAccent,
                        ),
                      ),
                      horizontalSpace(12),
                      Expanded(
                        child: _buildMetricCard(
                          isDark,
                          'Total Streaks',
                          '$totalStreaks Days',
                          Icons.local_fire_department,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(24), 
                  _buildSectionTitle(isDark, 'Individual Performance'),
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
                  _buildInsightBox(isDark, avgCompletion),
                  verticalSpace(24), 
                ],
              ),
            ),
    );
  }

  // --- UI Helper Methods ---

  Widget _buildSectionTitle(bool isDark, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildWeeklyHeatmap(bool isDark, List<Map<String, dynamic>> habits) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    List<double> dailyActivity = List.filled(7, 0.0);

    for (int i = 0; i < 7; i++) {
      int completedCount = 0;
      for (var habit in habits) {
        final weekProgress = List<bool>.from(habit['weekProgress'] ?? List.filled(7, false));
        if (weekProgress[i]) completedCount++;
      }
      dailyActivity[i] = habits.isEmpty ? 0 : completedCount / habits.length;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          return Column(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                      alpha: dailyActivity[index].clamp(0.1, 1.0)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: dailyActivity[index] >= 0.5
                    ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                    : null,
              ),
              verticalSpace(8),
              Text(
                days[index],
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMetricCard(bool isDark, String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24.sp),
          verticalSpace(12), 
          Text(value,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87)),
          Text(label,
              style: TextStyle(
                  fontSize: 11.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildHabitProgressLine(bool isDark, String name, double progress, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white70 : Colors.black87)),
              Text('${(progress * 100).toInt()}%',
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ],
          ),
          verticalSpace(8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7.h,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightBox(bool isDark, double avgProgress) {
    String message = avgProgress > 0.5 
        ? "You're doing great! Your consistency is above average." 
        : "Keep going! Small steps lead to big changes.";
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.indigo.shade900, Colors.blueAccent.shade700]
              : [Colors.blue.shade50, Colors.blue.shade100],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Text('💡', style: TextStyle(fontSize: 24.sp)),
          horizontalSpace(16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.white : Colors.blue.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Text(
        'No habits tracked yet.',
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
    );
  }
}