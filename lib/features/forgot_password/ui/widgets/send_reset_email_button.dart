import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/features/forgot_password/logic/cubit/forgot_password_cubit.dart';
import 'package:routina/features/forgot_password/logic/cubit/forgot_password_state.dart';


class SendResetEmailButton extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback onSuccess;

  const SendResetEmailButton({
    super.key,
    required this.emailController,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.success) {
          onSuccess();
        } else if (state.status == ForgotPasswordStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ForgotPasswordStatus.loading;

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
                  : () => context.read<ForgotPasswordCubit>().sendResetPasswordEmail(emailController.text),
              borderRadius: BorderRadius.circular(18.r),
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5.w,
                        ),
                      )
                    : Text(
                        'Send Reset Link',
                        style: AppTextStyles.font18WhiteExtraBold.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}