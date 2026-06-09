part of 'habit_progress_charts_screen.dart';

extension EmptyState on HabitProgressChartsScreen {
  Widget _buildEmptyState(bool isDark, BuildContext context) {
    return Center(
      child: Text(
        context.l10n.noHabitsYet,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
    );
  }
}
