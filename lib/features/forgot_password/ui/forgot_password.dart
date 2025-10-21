import 'package:flutter/material.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/features/forgot_password/ui/widgets/forgot_password_screen_back_to_login_button.dart';
import 'package:routina/features/forgot_password/ui/widgets/forgot_password_screen_email_field.dart';
import 'package:routina/features/forgot_password/ui/widgets/forgot_password_screen_logo.dart';
import 'package:routina/features/forgot_password/ui/widgets/forgot_password_screen_success_state.dart';
import 'package:routina/features/forgot_password/ui/widgets/forgot_password_screen_success_state_texts.dart';
import 'package:routina/features/forgot_password/ui/widgets/forgot_password_screen_texts.dart';
import 'package:routina/features/forgot_password/ui/widgets/send_reset_email_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundGradientStart,
        // backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pushReplacementNamed(Routes.loginScreen),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundGradientStart,
              AppColors.backgroundGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_emailSent) ...[
                  // Logo
                  ForgotPasswordScreenLogo(),
                  const SizedBox(height: 32),
                  // Texts
                  ForgotPasswordScreenTexts(),
                  const SizedBox(height: 48),
                  // Email Field
                  ForgotPasswordScreenEmailField(emailController: _emailController),
                  const SizedBox(height: 24),
                  // Send Reset Email Button
                  SendResetEmailButton(emailController: _emailController),
                ] else ...[
                  // Success State
                  ForgotPasswordScreenSuccessState(),
                  const SizedBox(height: 32),
                  Text(
                    'Email Sent!',
                    style: AppTextStyles.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ForgotPasswordScreenSuccessStateTexts(emailController: _emailController),
                  const SizedBox(height: 32),
                  ForgotPasswordScreenBackToLoginButton(),
                ],
                const SizedBox(height: 16),
                // Back to Login
                if (!_emailSent)
                  TextButton(
                    onPressed: () =>
                        context.pushReplacementNamed(Routes.loginScreen),
                    child: Text(
                      'Back to Login',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  
              ],
            ),
          ),
        ),
      ),
    );
  }
}
