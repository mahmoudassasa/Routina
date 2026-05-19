part of '../privacy_policy_screen.dart';

extension Footer on PrivacyPolicyScreen {
  Widget _buildFooter(bool isDark, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Text(
        context.l10n.copyright,
        style: AppTextStyles.bodySmall.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}