import 'package:flutter/material.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () =>
          context.pushReplacementNamed(Routes.forgetPasswordScreen),
      child: Text(
        context.l10n.forgotPassword,
        style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
      ),
    );
  }
}
