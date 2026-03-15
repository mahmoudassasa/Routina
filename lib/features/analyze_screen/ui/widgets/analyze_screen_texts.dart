import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';

class AnalyzeScreenTexts extends StatelessWidget {
  const AnalyzeScreenTexts({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          'AI Analysis',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Get personalized insights and recommendations based on your habit patterns and progress.',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}