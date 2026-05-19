import 'package:flutter/material.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class RegisterScreenTexts extends StatelessWidget {
  const RegisterScreenTexts({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Main Title
        Text(
          context.l10n.createAccount,
          style: AppTextStyles.displayMedium.copyWith(
            // Ensure title is white or near-white in dark mode
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        verticalSpace(8),

        // Subtitle
        Text(
          context.l10n.registerSubtitle,
          style: AppTextStyles.bodyLarge.copyWith(
            // Use a softer grey for dark mode to maintain hierarchy
            color: isDark
                ? Colors.white.withValues(alpha: 0.7)
                : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
