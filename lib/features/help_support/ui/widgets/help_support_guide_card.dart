part of '../help_support_screen.dart';

extension _HelpSupportGuideCard on _HelpSupportScreenState {
  Widget _guidesSection() => Column(children: _guides.map(_guideCard).toList());

  Widget _guideCard(_GuideItem guide) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: _surfaceLightColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _borderColor.withValues(alpha: 0.6)),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: _isDark
                ? AppColors.primaryDark.withValues(alpha: 0.3)
                : AppColors.primaryLighter,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(guide.icon, color: AppColors.primary, size: 20.sp),
        ),
        title: Text(
          guide.title,
          style: AppTextStyles.titleMedium.copyWith(color: _textPrimary),
        ),
        iconColor: AppColors.primary,
        collapsedIconColor: _iconSubtle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              top: 4.h,
            ),
            child: Column(
              children: guide.steps
                  .asMap()
                  .entries
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 11.r,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              '${e.key + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          horizontalSpace(10),
                          Expanded(
                            child: Text(
                              e.value,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: _textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
