part of '../email_confirmation_screen.dart';

class _SecondaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;
  final bool isDark;

  const _SecondaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
}