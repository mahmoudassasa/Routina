import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/habit_tracker_screen_coming_soon_content.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/habit_tracker_screen_header.dart';

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkBackgroundGradientStart, AppColors.darkBackgroundGradientEnd]
              : [AppColors.backgroundGradientStart, AppColors.backgroundGradientEnd],
        ),
      ),
      child: const SafeArea(
        child: Column(
          children: [
            HabitTrackerScreenHeader(),
            Expanded(
              child: HabitTrackerScreenComingSoonContent(),
            ),
          ],
        ),
      ),
    );
  }
}