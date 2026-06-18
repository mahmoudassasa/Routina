part of 'habit_progress_charts_screen.dart';

extension WeeklyHeatmap on HabitProgressChartsScreen {
  Widget _buildWeeklyHeatmap(
    bool isDark,
    List<Map<String, dynamic>> habits,
    BuildContext context,
  ) {
    final days = [
      context.l10n.monday,
      context.l10n.tuesday,
      context.l10n.wednesday,
      context.l10n.thursday,
      context.l10n.friday,
      context.l10n.saturday,
      context.l10n.sunday,
    ];
    List<double> dailyActivity = List.filled(7, 0.0);
    for (int i = 0; i < 7; i++) {
      int completedCount = 0;
      for (var habit in habits) {
        final weekProgress = List<bool>.from(
          habit['weekProgress'] ?? List.filled(7, false),
        );
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
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
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
                    alpha: dailyActivity[index].clamp(0.1, 1.0),
                  ),
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
}
