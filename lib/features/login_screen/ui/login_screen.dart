import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
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
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.success) {
                context.pushReplacementNamed(Routes.mainLayout);
              } else if (state.status == LoginStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Login failed'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      LoginScreenLogo(),
                      const SizedBox(height: 32),
                      // Texts
                      LoginScreenTexts(),
                      const SizedBox(height: 48),
                      // Email Field
                      LoginScreenEmailField(emailController: _emailController),
                      const SizedBox(height: 16),
                      // Password Field
                      LoginScreenPasswordField(
                        passwordController: _passwordController,
                        isPasswordVisible: _isPasswordVisible,
                        togglePasswordVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      // Login Button
                      LoginButton(
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                      const SizedBox(height: 16),
                      // Forgot Password
                      ForgotPassword(),
                      const SizedBox(height: 16),
                      // Sign Up Link
                      AlreadyHaveAnAccount(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
