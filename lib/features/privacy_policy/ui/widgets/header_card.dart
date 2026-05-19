part of '../privacy_policy_screen.dart';

extension HeaderCard on PrivacyPolicyScreen {
  Widget _buildHeaderCard(bool isDark, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.primaryDark.withValues(alpha: 0.3),
                  AppColors.darkSurface,
                ]
              : [AppColors.primaryLighter, AppColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_rounded, color: AppColors.primary, size: 32.sp),
          verticalSpace(12),
          Text(
            context.l10n.yourPrivacyMatters,
            style: AppTextStyles.titleLarge.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          verticalSpace(6),
          Text(
            context.l10n.lastUpdated,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
