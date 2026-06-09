part of '../email_confirmation_screen.dart';

class _EmailIcon extends StatelessWidget {
  final bool isDark;

  const _EmailIcon({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}