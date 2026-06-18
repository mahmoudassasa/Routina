import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/locale/logic/locale_cubit.dart';

class ProfileScreenLanguageSwitch extends StatelessWidget {
  const ProfileScreenLanguageSwitch({super.key});

  Widget _langButton(BuildContext context, String label, Locale locale) {
    final current = context.watch<LocaleCubit>().state;
    final isSelected = current == locale;
    return GestureDetector(
      onTap: () => context.read<LocaleCubit>().setLocale(locale),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _langButton(context, 'EN', const Locale('en')),
        SizedBox(width: 8.w),
        _langButton(context, 'AR', const Locale('ar')),
      ],
    );
  }
}
