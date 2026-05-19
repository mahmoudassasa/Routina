import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/features/forgot_password/logic/cubit/forgot_password_cubit.dart';
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
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // We wrap everything in BlocProvider so SendResetEmailButton can find it
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            // 1. Dynamic Background
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isDark ? const Color(0xFF1A1A1A) : AppColors.backgroundGradientStart,
                    isDark ? Colors.black : AppColors.backgroundGradientEnd,
                  ],
                ),
              ),
            ),

            // 2. Main Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      verticalSpace(40),
                      if (!_emailSent) ...[
                        const ForgotPasswordScreenLogo(),
                        verticalSpace(24),
                        const ForgotPasswordScreenTexts(),
                        verticalSpace(48),
                        ForgotPasswordScreenEmailField(emailController: _emailController),
                        verticalSpace(24),
                        SendResetEmailButton(
                          emailController: _emailController,
                          onSuccess: () {
                            setState(() {
                              _emailSent = true;
                            });
                          },
                        ),
                        verticalSpace(24),
                        TextButton(
                          onPressed: () => context.pushReplacementNamed(Routes.loginScreen),
                          child: Text(
                            context.l10n.backToLogin,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: isDark ? AppColors.primaryLight : AppColors.primary,
                            ),
                          ),
                        ),
                      ] else ...[
                        const ForgotPasswordScreenSuccessState(),
                        verticalSpace(32),
                        Text(
                          context.l10n.emailSent,
                          style: AppTextStyles.displayMedium.copyWith(
                            color: isDark ? Colors.white : AppColors.textPrimary,
                            fontSize: 28.sp, // Ensuring ScreenUtil
                          ),
                          textAlign: TextAlign.center,
                        ),
                        verticalSpace(8),
                        ForgotPasswordScreenSuccessStateTexts(emailController: _emailController),
                        verticalSpace(32),
                        const ForgotPasswordScreenBackToLoginButton(),
                      ],
                      verticalSpace(20),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Floating Theme Toggle
            Positioned(
              top: 50.h,
              left: 20.w,
              child: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return FloatingActionButton.small(
                    heroTag: 'themeToggleForgot',
                    elevation: 0,
                    backgroundColor: isDark 
                        ? Colors.white10 
                        : AppColors.primary.withValues(alpha: 0.1),
                    shape: CircleBorder(
                      side: BorderSide(
                        color: isDark ? Colors.white24 : AppColors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    child: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: isDark ? Colors.amber[400] : AppColors.primary,
                      size: 20.sp,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}