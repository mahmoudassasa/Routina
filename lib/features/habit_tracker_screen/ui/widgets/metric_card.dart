part of 'habit_progress_charts_screen.dart';

extension MetricCard on HabitProgressChartsScreen {
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
}