import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/login_screen/logic/cubit/login_cubit.dart';
import 'package:routina/features/login_screen/logic/cubit/login_state.dart';

class GoogleSignin extends StatelessWidget {
  const GoogleSignin({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? Colors.white12 : AppColors.border.withValues(alpha: 0.6);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: dividerColor,
                thickness: 1.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                context.l10n.orContinueWith,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: dividerColor,
                thickness: 1.h,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        // Wrapped in BlocBuilder so the button can disable itself while
        // a sign-in is already in progress. Prevents double-tapping
        // from launching two concurrent Google Sign-In flows (e.g. two
        // account picker sheets, or two competing signInWithGoogle()
        // calls racing against each other).
        BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final isLoading = state.status == LoginStatus.loading;
            return SizedBox(
              width: double.infinity,
              height: 54.h,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => context.read<LoginCubit>().signInWithGoogle(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
                  foregroundColor: isDark ? Colors.white : Colors.black87,
                  elevation: isDark ? 0 : 3,
                  shadowColor: isDark ? Colors.transparent : Colors.black.withValues(alpha: 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    side: BorderSide(
                      color: dividerColor,
                      width: 1.w,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: isDark ? Colors.white70 : AppColors.primary,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/google.svg',
                            width: 22.w,
                            height: 22.w,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            context.l10n.google,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}