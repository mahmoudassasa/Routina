import 'package:flutter/material.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class ForgotPasswordScreenSuccessStateTexts extends StatelessWidget {
  final TextEditingController _emailController;
  const ForgotPasswordScreenSuccessStateTexts({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Using RichText to highlight the email address
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTextStyles.bodyLarge.copyWith(
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
            children: [
              const TextSpan(text: 'We\'ve sent a password reset link to\n'),
              TextSpan(
                text: _emailController.text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),

        verticalSpace(32),

        Text(
          'Didn\'t receive the email? Check your spam folder or try again in a few minutes.',
          style: AppTextStyles.bodyMedium.copyWith(
            // Using a lighter tint for dark mode readability
            color: isDark ? Colors.white54 : AppColors.textLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
