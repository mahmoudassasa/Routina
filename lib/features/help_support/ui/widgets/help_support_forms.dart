part of '../help_support_screen.dart';

extension _HelpSupportForms on _HelpSupportScreenState {
  Widget _bugReportForm() {
    final bgColor = _isDark
        ? AppColors.error.withValues(alpha: 0.1)
        : AppColors.errorLight;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bug_report_rounded,
                color: AppColors.error,
                size: 20.sp,
              ),
              horizontalSpace(8),
              Text(
                context.l10n.somethingNotWorking,
                style: AppTextStyles.titleMedium.copyWith(color: _textPrimary),
              ),
            ],
          ),
          verticalSpace(16),
          _inputField(
            controller: _bugSubjectController,
            label: context.l10n.issueTitle,
            hint: context.l10n.issueTitleHint,
          ),
          verticalSpace(12),
          _inputField(
            controller: _bugBodyController,
            label: context.l10n.describeTheBug,
            hint: context.l10n.describeTheBugHint,
            maxLines: 4,
          ),
          verticalSpace(16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submitBugReport,
              icon: Icon(Icons.send_rounded, size: 18.sp),
              label: Text(context.l10n.sendBugReport),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactForm() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: _surfaceLightColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          _inputField(
            controller: _contactNameController,
            label: context.l10n.yourName,
            hint: context.l10n.yourNameHint,
          ),
          verticalSpace(12),
          _inputField(
            controller: _contactMessageController,
            label: context.l10n.message,
            hint: context.l10n.messageHint,
            maxLines: 4,
          ),
          verticalSpace(16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submitContactForm,
              icon: Icon(Icons.email_rounded, size: 18.sp),
              label: Text(context.l10n.sendMessage),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legalSection() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceLightColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          _legalTile(
            icon: Icons.shield_rounded,
            title: context.l10n.privacyPolicy,
            subtitle: context.l10n.privacyPolicySubtitle,
            onTap: () => context.pushNamed(Routes.privacyPolicyScreen),
          ),
          Divider(height: 1.h, color: _borderColor),
          _legalTile(
            icon: Icons.open_in_new_rounded,
            title: context.l10n.privacyPolicyWeb,
            subtitle: context.l10n.privacyPolicyWebSubtitle,
            onTap: _launchPrivacyPolicyWeb,
            iconColor: AppColors.primaryLight,
          ),
        ],
      ),
    );
  }

  Widget _legalTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 20.sp,
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: _textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: _iconSubtle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.bodyMedium.copyWith(color: _textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: _textSecondary),
        hintText: hint,
        hintStyle: AppTextStyles.bodySmall.copyWith(color: _iconSubtle),
        filled: true,
        fillColor: _surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:  BorderSide(color: AppColors.primary, width: 1.5.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }
}
