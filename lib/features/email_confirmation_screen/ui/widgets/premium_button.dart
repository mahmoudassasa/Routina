part of '../email_confirmation_screen.dart';

class _PremiumButton extends StatelessWidget {
  final String label;
  final bool isDisabled;
  final VoidCallback onPressed;
  final bool isDark;
  final bool isLoading;

  const _PremiumButton({
    required this.label,
    required this.isDisabled,
    required this.onPressed,
    required this.isDark,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
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
}