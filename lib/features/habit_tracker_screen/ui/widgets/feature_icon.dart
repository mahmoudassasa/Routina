part of 'feature_bottom_sheet.dart';

class _FeatureIcon extends StatelessWidget {
  final String icon;

  const _FeatureIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withBlue(255)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Center(
        child: Text(icon, style: TextStyle(fontSize: 40.sp)),
      ),
    );
  }
}