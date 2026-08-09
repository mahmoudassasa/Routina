import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/widgets/social_auth_button.dart';
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
import 'package:routina/features/register_screen/ui/widgets/register_screen_phone_field.dart';
import 'package:routina/features/register_screen/ui/widgets/register_screen_birth_date_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'EG');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final defaultFillColor = isDark
        ? AppColors.darkBackgroundLight
        : AppColors.backgroundLight;

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
                        verticalSpace(40),
                        const RegisterScreenLogo(),
                        verticalSpace(24),
                        const RegisterScreenTexts(),
                        verticalSpace(24),
                        const RegisterScreenUserPicture(),
                        verticalSpace(24),
                        RegisterScreenNameField(
                          nameController: _nameController,
                        ),
                        verticalSpace(16),
                        RegisterScreenEmailField(
                          emailController: _emailController,
                        ),
                        verticalSpace(16),
                        RegisterScreenPhoneField(
                          phoneController: _phoneController,
                          phoneNumber: _phoneNumber,
                          onInputChanged: (PhoneNumber number) {
                            setState(() {
                              _phoneNumber = number;
                            });
                          },
                        ),
                        verticalSpace(16),
                        RegisterScreenBirthDateField(
                          dobController: _dobController,
                          onTap: () => _selectDate(context),
                        ),
                        verticalSpace(16),
                        RegisterScreenPasswordfield(
                          passwordController: _passwordController,
                        ),
                        verticalSpace(24),
                        RegisterScreenRegisterButton(
                          formKey: _formKey,
                          nameController: _nameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          phoneController: _phoneController,
                          dobController: _dobController,
                          phoneNumber: _phoneNumber.phoneNumber ?? '',
                        ),
                        verticalSpace(24),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: borderColor,
                                thickness: 1.h,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                context.l10n.orContinueWith,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.black54,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: borderColor,
                                thickness: 1.h,
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(24),
                        SocialAuthButton(
                          iconPath: 'assets/icons/google.svg',
                          label: context.l10n.google,
                          containerBg: defaultFillColor,
                          borderColor: borderColor,
                          textColor: isDark ? Colors.white : Colors.black87,
                          onPressed: () {
                            context.read<RegisterCubit>().registerWithGoogle();
                          },
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
            top: 50.h,
            left: 20.w,
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
