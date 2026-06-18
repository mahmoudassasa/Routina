part of 'habit_progress_charts_screen.dart';

extension InsightBox on HabitProgressChartsScreen {
  Widget _buildInsightBox(
    bool isDark,
    double avgProgress,
    BuildContext context,
  ) {
    String message = avgProgress > 0.5
        ? context.l10n.insightGreat
        : context.l10n.insightKeepGoing;
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
}
