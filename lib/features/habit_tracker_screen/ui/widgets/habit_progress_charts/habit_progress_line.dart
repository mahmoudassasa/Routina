part of '../habit_progress_charts_screen.dart';

extension HabitProgressLine on HabitProgressChartsScreen {
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
}