import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/features/profile_screen/logic/cubit/delete_account_cubit.dart';

void showDeleteAccountSheet(BuildContext context) {
  final cubit = DeleteAccountCubit();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) =>
        BlocProvider.value(value: cubit, child: const _DeleteAccountSheet()),
  );
}

class _DeleteAccountSheet extends StatefulWidget {
  const _DeleteAccountSheet();

  @override
  State<_DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<_DeleteAccountSheet> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _surfaceColor =>
      _isDark ? AppColors.darkSurface : AppColors.surface;
  Color get _borderColor => _isDark ? AppColors.darkBorder : AppColors.border;
  Color get _textPrimary =>
      _isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get _textSecondary =>
      _isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getErrorMessage(BuildContext context, String? errorCode) {
    return switch (errorCode) {
      'wrong-password' => context.l10n.wrongPassword,
      'user-mismatch' => context.l10n.userMismatch,
      'invalid-credential' => context.l10n.invalidCredential,
      'cancelled' => context.l10n.operationCancelled,
      'missing-credentials' => context.l10n.fillAllFields,
      _ => context.l10n.unexpectedError(''),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isGoogle = context.read<DeleteAccountCubit>().isGoogleUser;

    return BlocListener<DeleteAccountCubit, DeleteAccountState>(
      listener: (context, state) {
        if (state.status == DeleteAccountStatus.success) {
          context.pop();
          context.pushNamedAndRemoveUntil(
            Routes.loginScreen,
            predicate: (route) => false,
          );
        } else if (state.status == DeleteAccountStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getErrorMessage(context, state.errorCode)),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: _borderColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              verticalSpace(20),

              // Icon
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.error,
                  size: 28.sp,
                ),
              ),
              verticalSpace(16),

              Text(
                context.l10n.deleteAccount,
                style: AppTextStyles.titleLarge.copyWith(color: _textPrimary),
              ),
              verticalSpace(8),
              Text(
                context.l10n.deleteAccountWarning,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(color: _textSecondary),
              ),
              verticalSpace(24),

              if (!isGoogle) ...[
                _inputField(
                  controller: _emailController,
                  label: context.l10n.email,
                  hint: context.l10n.emailHint,
                ),
                verticalSpace(12),
                _inputField(
                  controller: _passwordController,
                  label: context.l10n.password,
                  hint: context.l10n.passwordHint,
                  obscure: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: _textSecondary,
                      size: 20.sp,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                verticalSpace(24),
              ],

              // Buttons
              BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
                builder: (context, state) {
                  final isLoading = state.status == DeleteAccountStatus.loading;

                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context
                                      .read<DeleteAccountCubit>()
                                      .deleteAccount(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text
                                            .trim(),
                                      );
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(context.l10n.deleteAccount),
                        ),
                      ),
                      verticalSpace(12),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: isLoading ? null : () => context.pop(),
                          child: Text(
                            context.l10n.cancel,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: _textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              verticalSpace(8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: AppTextStyles.bodyMedium.copyWith(color: _textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: _textSecondary),
        hintText: hint,
        hintStyle: AppTextStyles.bodySmall.copyWith(color: _textSecondary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: _isDark ? AppColors.darkBackground : AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }
}
