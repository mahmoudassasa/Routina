import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/login_screen/logic/cubit/login_cubit.dart';
import 'package:routina/features/login_screen/logic/cubit/login_state.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController emailController;

  const LoginButton({
    super.key,
    required this.passwordController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        bool isLoading = state.status == LoginStatus.loading;

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
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.missingCredentials),
                          ),
                        );
                        return;
                      }
                      context.read<LoginCubit>().login(email, password);
                    },
              borderRadius: BorderRadius.circular(18.r),
              child: Center(
                child: isLoading
                    ?  SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        context.l10n.login,
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
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
