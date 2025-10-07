import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class LoginScreenTexts extends StatelessWidget {
  const LoginScreenTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        const Text(
          'Welcome Back',
          style: AppTextStyles.displayMedium,
          textAlign: TextAlign.center,
        ),
    
        const SizedBox(height: 8),
    
        Text(
          'Sign in to continue tracking your habits',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
