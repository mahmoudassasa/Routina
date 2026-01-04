import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';

class HabitTrackerScreenHeader extends StatelessWidget {
  const HabitTrackerScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Decorative Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
                border: isDark 
                    ? Border.all(color: AppColors.primary.withValues(alpha: 0.2)) 
                    : null,
              ),
              child: const Center(
                child: Text('📊', style: TextStyle(fontSize: 24)),
              ),
            ),

            const SizedBox(width: 16),

            // Header Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Habit Tracker',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Detailed view of your progress',
                  style: TextStyle(
                    fontSize: 14, // Slightly smaller for better hierarchy
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}