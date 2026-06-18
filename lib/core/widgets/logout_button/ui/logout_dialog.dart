import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_cubit.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_state.dart';

Future<void> showLogoutDialog(BuildContext context) async {
  final logoutCubit = context.read<LogoutCubit>();
  logoutCubit.resetState(); // Clear any previous error

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider.value(
        value: logoutCubit,
        child: BlocListener<LogoutCubit, LogoutState>(
          listener: (context, state) {
            if (state.status == LogoutStatus.success) {
              context.pop();
            }
          },
          child: Dialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkSurface
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
              child: BlocBuilder<LogoutCubit, LogoutState>(
                builder: (context, state) {
                  final isProcessing = state.status == LogoutStatus.loading;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Friendly Header
                      _buildAnimatedHeader(isProcessing),

                      verticalSpace(24),
                      Text(
                        isProcessing
                            ? context.l10n.seeYouSoon
                            : context.l10n.leavingSoSoon,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),

                      verticalSpace(12),
                      Text(
                        isProcessing
                            ? context.l10n.logoutProcessMsg
                            : context.l10n.logoutConfirmMsg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          height: 1.5.h,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),

                      verticalSpace(32),
                      _buildActionButtons(context, isProcessing),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildAnimatedHeader(bool isProcessing) {
  return Container(
    width: 80.w,
    height: 80.w,
    decoration: BoxDecoration(
      color: isProcessing
          ? AppColors.primary.withValues(alpha: 0.1)
          : Colors.red.withValues(alpha: 0.1),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: isProcessing
          ? SizedBox(
              width: 32.w,
              height: 32.w,
              child: const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            )
          : Text("🥺", style: TextStyle(fontSize: 40.sp)),
    ),
  );
}

Widget _buildActionButtons(BuildContext context, bool isProcessing) {
  if (isProcessing) return const SizedBox.shrink();

  return Row(
    children: [
      // Left Button: Stay with us
      Expanded(
        flex: 2, // Increased flex to give more space
        child: TextButton(
          onPressed: () => context.pop(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero, // Remove internal padding to save space
          ),
          child: FittedBox(
            // Scales text down slightly if it's too long for the screen
            fit: BoxFit.scaleDown,
            child: Text(
              context.l10n.stayWithUs,
              maxLines: 1,
              style: TextStyle(
                fontSize: 15.sp, // Slightly smaller font for better fit
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),

      horizontalSpace(8), // Slightly smaller gap
      // Right Button: Yes, Log Out
      Expanded(
        flex: 3, // Balanced flex
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.red.shade700],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.read<LogoutCubit>().logout(),
              borderRadius: BorderRadius.circular(16.r),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      context.l10n.yesLogOut,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
