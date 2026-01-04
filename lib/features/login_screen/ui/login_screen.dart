import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/widgets/main_alert_dialog.dart';
import 'package:routina/features/login_screen/logic/cubit/login_cubit.dart';
import 'package:routina/features/login_screen/logic/cubit/login_state.dart';
import 'package:routina/features/login_screen/ui/widgets/already_have_an_account.dart';
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
              dialogTitle: const Text("Login Error"),
              dialogContent: Text(state.errorMessage ?? "Login failed"),
              dialogActions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text("OK"),
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
                    isDark ? const Color(0xFF1A1A1A) : AppColors.backgroundGradientStart,
                    isDark ? Colors.black : AppColors.backgroundGradientEnd,
                  ],
                ),
              ),
            ),
            
            Positioned(
              top: 50,
              left: 20,
              child: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return FloatingActionButton.small(
                    heroTag: 'themeToggleLogin',
                    elevation: 0,
                    backgroundColor: isDark ? Colors.white10 : AppColors.primary.withValues(alpha: 0.1),
                    shape: CircleBorder(
                      side: BorderSide(
                        color: isDark ? Colors.white24 : AppColors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    child: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: isDark ? Colors.amber[400] : AppColors.primary,
                    ),
                  );
                },
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LoginScreenLogo(),
                      const SizedBox(height: 32),
                      const LoginScreenTexts(),
                      const SizedBox(height: 48),
                      LoginScreenEmailField(emailController: _emailController),
                      const SizedBox(height: 16),
                      LoginScreenPasswordField(
                        passwordController: _passwordController,
                      ),
                      const SizedBox(height: 24),
                      LoginButton(
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                      const SizedBox(height: 24),
                      const ForgotPassword(),
                      const SizedBox(height: 16),
                      const AlreadyHaveAnAccount(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}