import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class RegisterScreenTexts extends StatelessWidget {
  const RegisterScreenTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      
        // Texts
        const Text(
          'Create Account',
          style: AppTextStyles.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Join us and start building better habits',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
