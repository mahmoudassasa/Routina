import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/features/register_screen/logic/cubit/register_cubit.dart';
import 'package:routina/features/register_screen/logic/cubit/register_state.dart';

class RegisterScreenRegisterButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterScreenRegisterButton({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        bool isLoading = state.status == RegisterStatus.loading;

        return Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isDark
                  ? [AppColors.primary, AppColors.primary.withBlue(255)]
                  : [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)],
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
                      context.read<RegisterCubit>().register(
                            nameController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                    },
              borderRadius: BorderRadius.circular(18),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Create Account',
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