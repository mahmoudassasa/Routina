import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/register_screen/logic/cubit/register_cubit.dart';
import 'package:routina/features/register_screen/logic/cubit/register_state.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_email_field.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_login_link.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_name_field.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_password_field.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_register_button.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_texts.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_logo.dart';

import '../../../core/routing/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
          child: BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state.status == RegisterStatus.success) {
                context.pushReplacementNamed(Routes.emailConfirmationScreen);

              } else if (state.status == RegisterStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Registration failed'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      RegisterScreenLogo(),
                      const SizedBox(height: 32),
                      RegisterScreenTexts(),
                      const SizedBox(height: 48),
                      // Name Field
                      RegisterScreenNameField(nameController: _nameController),
                      const SizedBox(height: 16),
                      // Email Field
                      RegisterScreenEmailField(
                        emailController: _emailController,
                      ),
                      verticalSpace(16),
                      // Password Field
                      RegisterScreenPasswordfield(
                        passwordController: _passwordController,
                        //  passwordController: _passwordController,
                        //isPasswordVisible: _isPasswordVisible,
                      ),
                      const SizedBox(height: 24),
                      // Register Button
                      RegisterScreenRegisterButton(
                        nameController: _nameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                      const SizedBox(height: 32),
                      // Login In Link
                      RegisterScreenLoginLink(),
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
