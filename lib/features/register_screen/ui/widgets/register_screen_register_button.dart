import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/features/register_screen/logic/cubit/register_cubit.dart';
import 'package:routina/features/register_screen/logic/cubit/register_state.dart';

class RegisterScreenRegisterButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final TextEditingController dobController;
  final String phoneNumber; // Changed from dialCode

  const RegisterScreenRegisterButton({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.dobController,
    required this.phoneNumber, // Changed
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        bool isLoading = state.status == RegisterStatus.loading;
        return Container(
          width: double.infinity,
          height: 58.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isDark
                  ? [AppColors.primary, AppColors.primary.withBlue(255)]
                  : [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.85),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading
                  ? null
                  : () {
                      if (!formKey.currentState!.validate()) return;
                      
                      // Removed manual concatenation to avoid duplicate country codes
                      context.read<RegisterCubit>().register(
                            nameController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            phoneNumber, // Pass the clean string directly
                            dobController.text.trim(),
                          );
                    },
              borderRadius: BorderRadius.circular(18.r),
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        context.l10n.createAccount,
                        style: AppTextStyles.font18WhiteExtraBold,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}