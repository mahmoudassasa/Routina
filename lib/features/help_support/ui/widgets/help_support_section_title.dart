part of '../help_support_screen.dart';

extension _HelpSupportSectionTitle on _HelpSupportScreenState {
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        horizontalSpace(10),
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(color: _textPrimary),
        ),
      ],
    );
  }
}
