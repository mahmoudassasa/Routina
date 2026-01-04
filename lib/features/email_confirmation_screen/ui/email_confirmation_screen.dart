import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/features/email_confirmation_screen/logic/cubit/email_verification_cubit.dart';

class EmailConfirmationScreen extends StatelessWidget {
  const EmailConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => EmailVerificationCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            // 1. Consistent Dynamic Background
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isDark ? const Color(0xFF1A1A1A) : AppColors.backgroundGradientStart,
                    isDark ? Colors.black : AppColors.backgroundGradientEnd,
                  ],
                ),
              ),
            ),
            
            // 2. Main Content Card
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.surface,
                      borderRadius: BorderRadius.circular(28.r),
                      border: Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
                      listener: _handleStateListeners,
                      builder: (context, state) {
                        final cubit = context.read<EmailVerificationCubit>();
                        return _buildBody(context, state, cubit, isDark);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateListeners(BuildContext context, EmailVerificationState state) {
    if (state is EmailVerificationEmailSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Verification email sent again ✅"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    if (state is EmailVerificationVerified) {
      _showSuccessDialog(context);
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          context.pop(); // Close dialog
          context.pushReplacementNamed(Routes.loginScreen);
        }
      });
    }

    if (state is EmailVerificationNotVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email is not verified yet ❗")),
      );
    }
  }

  Widget _buildBody(BuildContext context, EmailVerificationState state, EmailVerificationCubit cubit, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Visual Icon
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.primary.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_unread_rounded,
            size: 60.sp,
            color: isDark ? AppColors.primaryLight : AppColors.primary,
          ),
        ),
        verticalSpace(24),
        
        Text(
          "Confirm Your Email",
          style: AppTextStyles.displaySmall.copyWith(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        verticalSpace(12),
        
        Text(
          "We sent a verification link to your email.\nPlease check your inbox.",
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? Colors.white70 : AppColors.textSecondary,
          ),
        ),
        verticalSpace(32),

        // Primary Resend Button (Glow Effect)
        _buildPremiumButton(
          label: state is EmailVerificationTimerTick 
              ? "Resend in ${state.seconds}s" 
              : "Resend Email",
          isLoading: false,
          isDisabled: state is EmailVerificationTimerTick,
          onPressed: () => cubit.resendEmail(),
          isDark: isDark,
        ),

        verticalSpace(16),

        // Secondary "Check" Button (Outlined/Glass Effect)
        _buildPremiumSecondaryButton(
          label: "I Verified My Email ✓",
          isLoading: state is EmailVerificationLoading,
          onPressed: () => cubit.checkVerification(),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildPremiumButton({
    required String label,
    required bool isDisabled,
    required VoidCallback onPressed,
    required bool isDark,
    required bool isLoading,
  }) {
    return Container(
      width: double.infinity,
      height: 58.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isDisabled
              ? [Colors.grey.shade600, Colors.grey.shade700]
              : (isDark 
                  ? [AppColors.primary, AppColors.primary.withBlue(255)] 
                  : [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)]),
        ),
        boxShadow: [
          if (!isDisabled)
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
          onTap: (isDisabled || isLoading) ? null : onPressed,
          borderRadius: BorderRadius.circular(18.r),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : Text(label, style: AppTextStyles.font18WhiteExtraBold.copyWith(
                    color: isDisabled ? Colors.white60 : Colors.white,
                  )),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumSecondaryButton({
    required String label,
    required bool isLoading,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      height: 58.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark ? Colors.white24 : AppColors.primary.withValues(alpha: 0.5),
          width: 1.5,
        ),
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(18.r),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                  )
                : Text(
                    label,
                    style: AppTextStyles.font18WhiteExtraBold.copyWith(
                      color: isDark ? Colors.white : AppColors.primary,
                      fontSize: 16.sp,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, size: 80, color: Colors.greenAccent),
                verticalSpace(16),
                Text("Success!", style: AppTextStyles.displaySmall.copyWith(
                   color: isDark ? Colors.white : AppColors.textPrimary,
                )),
                verticalSpace(8),
                Text(
                  "Email verified! Redirecting to login...",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                     color: isDark ? Colors.white70 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}