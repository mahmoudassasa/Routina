import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class PhoneVerificationBadge extends StatelessWidget {
  final bool isVerified;
  final bool isLoading;
  final bool hasUnsavedChange;
  final VoidCallback onVerify;
  final VoidCallback onRevert;

  const PhoneVerificationBadge({
    super.key,
    required this.isVerified,
    required this.isLoading,
    required this.hasUnsavedChange,
    required this.onVerify,
    required this.onRevert,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeColor = isVerified
        ? const Color(0xFF22A559)
        : const Color(0xFFF2622E);
    final showBadgeSpinner = isLoading && !isVerified;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (isVerified || isLoading) ? null : onVerify,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 7.h,
            ),
            decoration: BoxDecoration(
              color: showBadgeSpinner
                  ? badgeColor.withValues(alpha: 0.6)
                  : badgeColor,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showBadgeSpinner)
                  SizedBox(
                    width: 13.sp,
                    height: 13.sp,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        Colors.white,
                      ),
                    ),
                  )
                else
                  Icon(
                    isVerified
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color: Colors.white,
                    size: 15.sp,
                  ),
                horizontalSpace(6),
                Text(
                  (isVerified
                          ? context.l10n.verified
                          : context.l10n.notVerified)
                      .toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasUnsavedChange && !isVerified && !isLoading) ...[
          horizontalSpace(10),
          GestureDetector(
            onTap: onRevert,
            child: Text(
              context.l10n.cancel,
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ],
    );
  }
}