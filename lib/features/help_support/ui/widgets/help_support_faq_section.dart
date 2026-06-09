part of '../help_support_screen.dart';

extension _HelpSupportFaqSection on _HelpSupportScreenState {
  Widget _faqSection() {
    return Column(
      children: _faqs.asMap().entries.map((e) {
        final i = e.key;
        final faq = e.value;
        final expanded = _expandedFaqIndex == i;
        final expandedBg = _isDark
            ? AppColors.primaryDark.withValues(alpha: 0.2)
            : AppColors.primaryLighter;
        final expandedBorder = _isDark
            ? AppColors.primaryLight.withValues(alpha: 0.35)
            : AppColors.primaryLight;
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: expanded ? expandedBg : _surfaceLightColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: expanded ? expandedBorder : _borderColor),
          ),
          child: InkWell(
            onTap: () => _updateFaqIndex(expanded ? null : i),
            borderRadius: BorderRadius.circular(14.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          faq.question,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: expanded ? AppColors.primary : _textPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                    ],
                  ),
                  if (expanded) ...[
                    verticalSpace(10),
                    Text(
                      faq.answer,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
