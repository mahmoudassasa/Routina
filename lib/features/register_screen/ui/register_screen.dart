import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/widgets/language_bottom_sheet.dart';
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

  void _showPreferencesSheet(BuildContext context, bool isDark) {
    final themeCubit = context.read<ThemeCubit>();
    final localeCubit = context.read<LocaleCubit>();
    final darkModeLabel = context.l10n.darkMode;
    final languageLabel = context.l10n.language;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: themeCubit),
          BlocProvider.value(value: localeCubit),
        ],
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return ListTile(
                    leading: Icon(
                      state.isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      darkModeLabel,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    trailing: Switch(
                      value: state.isDarkMode,
                      activeThumbColor: AppColors.primary,
                      onChanged: (_) =>
                          context.read<ThemeCubit>().toggleTheme(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.language_rounded,
                  color: AppColors.primary,
                ),
                title: Text(
                  languageLabel,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlocProvider.value(
                      value: localeCubit,
                      child: LanguageBottomSheet(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
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
                  context
                      .pushReplacementNamed(Routes.emailConfirmationScreen);
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
              onPressed: () => _showPreferencesSheet(context, isDark),
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