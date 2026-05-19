import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';

class ForgotPasswordScreenBackToLoginButton extends StatelessWidget {
  const ForgotPasswordScreenBackToLoginButton({super.key, this.textStyle});

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 58.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        // Premium Border using Gradient look
        border: Border.all(
          color: isDark
              ? Colors.white12
              : AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pushReplacementNamed(Routes.loginScreen),
          borderRadius: BorderRadius.circular(18.r),
          highlightColor: AppColors.primary.withValues(alpha: 0.05),
          splashColor: AppColors.primary.withValues(alpha: 0.1),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.sp,
                  color: isDark ? Colors.white70 : AppColors.primary,
                ),
                horizontalSpace(10),
                Text(
                  context.l10n.backToLogin,
                  style:
                      textStyle ??
                      TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
