import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class ForgotPasswordScreenTexts extends StatelessWidget {
  const ForgotPasswordScreenTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Forgot Password?',
          style: AppTextStyles.displayMedium,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Enter your email address and we\'ll send you a link to reset your password',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
