import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/locale/logic/locale_cubit.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = context.watch<LocaleCubit>().state;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          verticalSpace(20),
          Text(
            context.l10n.language,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          verticalSpace(20),
          _langTile(
            context,
            'English',
            '🇬🇧',
            const Locale('en'),
            current,
            isDark,
          ),
          verticalSpace(12),
          _langTile(
            context,
            'العربية',
            '🇸🇦',
            const Locale('ar'),
            current,
            isDark,
          ),
          verticalSpace(24),
        ],
      ),
    );
  }

  Widget _langTile(
    BuildContext context,
    String label,
    String flag,
    Locale locale,
    Locale current,
    bool isDark,
  ) {
    final isSelected = current == locale;
    return GestureDetector(
      onTap: () {
        context.read<LocaleCubit>().setLocale(locale);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : (isDark
                    ? AppColors.darkBackgroundLight
                    : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 24.sp)),
            horizontalSpace(12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary),
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
