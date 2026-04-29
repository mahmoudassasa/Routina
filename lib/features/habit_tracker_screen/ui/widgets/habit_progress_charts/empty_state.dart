part of '../habit_progress_charts_screen.dart';

extension EmptyState on HabitProgressChartsScreen {
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Text(
        'No habits tracked yet.',
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
    );
  }
}