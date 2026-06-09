import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class OnboardingPageView extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final List<Map<String, String>> pages;
  final ValueChanged<int> onPageChanged;

  const OnboardingPageView({
    required this.pageController,
    required this.currentPage,
    required this.pages,
    required this.onPageChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container (Matching Login Style)
              Container(
                width: 220.w,
                height: 110.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.primary.withValues(alpha: 0.1),
                    width: 1.5.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                      blurRadius: 25.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    pages[index]['icon']!,
                    style: TextStyle(
                      fontSize: 50.sp,
                    ),
                  ),
                ),
              ),

              verticalSpace(48), 

              // Title
              Text(
                pages[index]['title']!,
                style: AppTextStyles.displayMedium.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              verticalSpace(16), 

              // Subtitle
              Text(
                pages[index]['subtitle']!,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}