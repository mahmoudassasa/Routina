import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileLogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r), // Softer corners
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: isDark ? 0.05 : 0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: isDark
              ? Colors.redAccent.withValues(alpha: 0.08)
              : const Color(0xFFFFFBFA), // Very light warm tint
          borderRadius: BorderRadius.circular(20.r),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact(); // Subtle vibration for premium feel
              onTap();
            },
            borderRadius: BorderRadius.circular(20.r),
            splashColor: AppColors.error.withValues(alpha: 0.1),
            highlightColor: AppColors.error.withValues(alpha: 0.05),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: isDark ? 0.15 : 0.1),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  // Icon with friendly glassmorphism look
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.redAccent.withValues(alpha: 0.12)
                          : Colors.redAccent.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons
                          .power_settings_new_rounded, // Friendlier than standard logout icon
                      color: AppColors.error,
                      size: 22.sp,
                    ),
                  ),
                  horizontalSpace(16),
                  // Text
                  Text(
                    context.l10n.signOut,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                      letterSpacing: 0.3,
                    ),
                  ),

                  const Spacer(),

                  // Soft Arrow or Emoji
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.sp,
                    color: AppColors.error.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
