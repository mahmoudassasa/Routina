import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/widgets/main_alert_dialog.dart';
import 'package:routina/features/locale/logic/locale_cubit.dart';
import 'package:routina/features/login_screen/logic/cubit/login_cubit.dart';
import 'package:routina/features/login_screen/logic/cubit/login_state.dart';
import 'package:routina/features/login_screen/ui/widgets/already_have_an_account.dart';
import 'package:routina/features/login_screen/ui/widgets/google_signin.dart';
import 'package:routina/features/login_screen/ui/widgets/login_screen_email_field.dart';
import 'package:routina/features/login_screen/ui/widgets/forgot_password.dart';
import 'package:routina/features/login_screen/ui/widgets/login_button.dart';
import 'package:routina/features/login_screen/ui/widgets/login_screen_texts.dart';
import 'package:routina/features/login_screen/ui/widgets/login_screen_logo.dart';
import 'package:routina/features/login_screen/ui/widgets/login_screen_password_field.dart';
import '../../../core/routing/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _getErrorMessage(BuildContext context, LoginState state) {
    return switch (state.errorCode) {
      'invalidEmail' => context.l10n.invalidEmail,
      'userNotFound' => context.l10n.userNotFound,
      'wrongPassword' => context.l10n.wrongPassword,
      'invalidCredential' => context.l10n.invalidCredential,
      'missingPassword' => context.l10n.missingPassword,
      'tooManyRequests' => context.l10n.tooManyRequests,
      'userDisabled' => context.l10n.userDisabled,
      'googleSignInFailed' => context.l10n.googleSignInFailed,
      'pleaseVerifyEmail' => context.l10n.pleaseVerifyEmail,
      'unexpectedError' => context.l10n.unexpectedError(
        state.errorMessage ?? '',
      ),
      _ => context.l10n.loginFailed,
    };
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          context.pushReplacementNamed(Routes.mainNavigationBar);
        } else if (state.status == LoginStatus.error) {
          showDialog(
            context: context,
            builder: (_) => MainAlertDialog(
              dialogTitle: Text(context.l10n.loginError),
              dialogContent: Text(_getErrorMessage(context, state)),
              dialogActions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(context.l10n.ok),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isDark
                        ? const Color(0xFF1A1A1A)
                        : AppColors.backgroundGradientStart,
                    isDark ? Colors.black : AppColors.backgroundGradientEnd,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(32.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LoginScreenLogo(),
                      verticalSpace(32),
                      const LoginScreenTexts(),
                      verticalSpace(48),
                      LoginScreenEmailField(emailController: _emailController),
                      verticalSpace(16),
                      LoginScreenPasswordField(
                        passwordController: _passwordController,
                      ),
                      verticalSpace(24),
                      LoginButton(
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                      verticalSpace(16),
                      GoogleSignin(),
                      verticalSpace(16),
                      const ForgotPassword(),
                      verticalSpace(8),
                      const AlreadyHaveAnAccount(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: FloatingActionButton.small(
                heroTag: 'settingsLogin',
                elevation: 0,
                backgroundColor: isDark
                    ? Colors.white10
                    : AppColors.primary.withValues(alpha: 0.1),
                shape: CircleBorder(
                  side: BorderSide(
                    color: isDark
                        ? Colors.white24
                        : AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                onPressed: () => context.showPreferencesSheet(
                  themeCubit: context.read<ThemeCubit>(),
                  localeCubit: context.read<LocaleCubit>(),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: isDark ? Colors.white70 : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
