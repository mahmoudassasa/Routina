import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/features/locale/logic/locale_cubit.dart';
import 'package:routina/features/register_screen/logic/cubit/register_cubit.dart';
import 'package:routina/features/register_screen/logic/cubit/register_state.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_email_field.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_login_link.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_name_field.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_password_field.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_register_button.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_texts.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_logo.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_user_picture.dart';
import 'package:routina/features/register_screen/ui/widgets/terms_of_service.dart';

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

  String _getErrorMessage(BuildContext context, RegisterState state) {
    return switch (state.errorCode) {
      'emailAlreadyInUse' => context.l10n.emailAlreadyInUse,
      'invalidEmail' => context.l10n.invalidEmail,
      'weakPassword' => context.l10n.weakPassword,
      'networkError' => context.l10n.networkError,
      _ => context.l10n.registerError,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
            child: BlocListener<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state.status == RegisterStatus.success) {
                  context.pushReplacementNamed(Routes.emailConfirmationScreen);
                } else if (state.status == RegisterStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_getErrorMessage(context, state)),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        verticalSpace(60),
                        const RegisterScreenLogo(),
                        verticalSpace(24),
                        const RegisterScreenTexts(),
                        verticalSpace(32),
                        const RegisterScreenUserPicture(),
                        verticalSpace(32),
                        RegisterScreenNameField(
                          nameController: _nameController,
                        ),
                        verticalSpace(16),
                        RegisterScreenEmailField(
                          emailController: _emailController,
                        ),
                        verticalSpace(16),
                        RegisterScreenPasswordfield(
                          passwordController: _passwordController,
                        ),
                        verticalSpace(32),
                        RegisterScreenRegisterButton(
                          nameController: _nameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                        verticalSpace(24),
                        termsAndConditionsText(context),
                        const RegisterScreenLoginLink(),
                        verticalSpace(20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: FloatingActionButton.small(
              heroTag: 'settingsRegister',
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
    );
  }
}
