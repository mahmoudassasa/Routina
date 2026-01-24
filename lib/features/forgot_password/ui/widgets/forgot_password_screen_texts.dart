import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class ForgotPasswordScreenTexts extends StatelessWidget {
  const ForgotPasswordScreenTexts({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the current theme is dark
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          'Forgot Password?',
          style: AppTextStyles.displayMedium.copyWith(
            // Use white for dark mode, primary text for light mode
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Enter your email address and we\'ll send you a link to reset your password',
          style: AppTextStyles.bodyLarge.copyWith(
            // Use a lighter gray (white70) for dark mode readability
            color: isDark ? Colors.white70 : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}