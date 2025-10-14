import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class ForgotPasswordScreenSuccessStateTexts extends StatefulWidget {
  final TextEditingController _emailController;
  const ForgotPasswordScreenSuccessStateTexts({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  @override
  State<ForgotPasswordScreenSuccessStateTexts> createState() =>
      _ForgotPasswordScreenSuccessStateTextsState();
}

class _ForgotPasswordScreenSuccessStateTextsState
    extends State<ForgotPasswordScreenSuccessStateTexts> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'We\'ve sent a password reset link to ${widget._emailController.text}',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        Text(
          'Didn\'t receive the email? Check your spam folder or try again in a few minutes.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
