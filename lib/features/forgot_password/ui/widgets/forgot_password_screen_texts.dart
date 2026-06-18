import 'package:flutter/material.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
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
          context.l10n.forgotPassword,
          style: AppTextStyles.displayMedium.copyWith(
            // Use white for dark mode, primary text for light mode
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        verticalSpace(8),

        Text(
          context.l10n.forgotPasswordDesc,
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
