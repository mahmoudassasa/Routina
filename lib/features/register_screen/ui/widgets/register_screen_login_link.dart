import 'package:flutter/material.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class RegisterScreenLoginLink extends StatelessWidget {
  const RegisterScreenLoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTextStyles.bodyMedium.copyWith(
            // Use white60 for dark mode to keep it subtle but readable
            color: isDark ? Colors.white60 : AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () => context.pushReplacementNamed(Routes.loginScreen),
          child: Text(
            'Sign In',
            style: AppTextStyles.labelLarge.copyWith(
              // Primary color remains consistent to draw attention
              color: isDark ? AppColors.primaryLight : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}