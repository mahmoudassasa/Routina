part of '../email_confirmation_screen.dart';

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: _SuccessDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 80,
            color: Colors.greenAccent,
          ),
          verticalSpace(16),
          Text(
            context.l10n.success,
            style: AppTextStyles.displaySmall.copyWith(
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          verticalSpace(8),
          Text(
            context.l10n.emailVerifiedRedirect,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
