part of '../help_support_screen.dart';

extension _HelpSupportAppBar on _HelpSupportScreenState {
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 140.h,
      pinned: true,
      backgroundColor: _scaffoldBg,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      leadingWidth: 56.w,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsetsDirectional.only(start: 56.w, bottom: 16.h),
        title: Text(
          context.l10n.helpAndSupport,
          style: AppTextStyles.headlineMedium.copyWith(color: _textPrimary),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isDark
                  ? [
                      AppColors.primaryDark.withValues(alpha: 0.25),
                      AppColors.darkBackground,
                    ]
                  : [
                      AppColors.primaryLighter.withValues(alpha: 0.5),
                      AppColors.background,
                    ],
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 24.w, top: 60.h),
              child: Icon(
                Icons.support_agent_rounded,
                size: 56.sp,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
