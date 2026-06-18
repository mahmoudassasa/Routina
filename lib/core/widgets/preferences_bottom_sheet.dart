import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/widgets/language_bottom_sheet.dart';
import 'package:routina/features/locale/logic/locale_cubit.dart';

class PreferencesBottomSheet extends StatelessWidget {
  const PreferencesBottomSheet({
    required this.themeCubit,
    required this.localeCubit,
    super.key,
  });

  final ThemeCubit themeCubit;
  final LocaleCubit localeCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider.value(value: localeCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final isDark = themeState.isDarkMode;
          return Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),
                _themeTile(context, isDark, themeState),
                verticalSpace(12),
                _languageTile(context, isDark),
                SizedBox(height: 8.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _themeTile(BuildContext context, bool isDark, ThemeState themeState) {
    return GestureDetector(
      onTap: () => context.read<ThemeCubit>().toggleTheme(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBackgroundLight
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(
              themeState.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: AppColors.primary,
              size: 24.sp,
            ),
            horizontalSpace(12),
            Text(
              context.l10n.darkMode,
              style: TextStyle(
                fontSize: 16.sp,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Switch(
              value: themeState.isDarkMode,
              activeThumbColor: AppColors.primary,
              onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageTile(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider.value(
            value: localeCubit,
            child: const LanguageBottomSheet(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBackgroundLight
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(Icons.language_rounded, color: AppColors.primary, size: 24.sp),
            horizontalSpace(12),
            Text(
              context.l10n.language,
              style: TextStyle(
                fontSize: 16.sp,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
