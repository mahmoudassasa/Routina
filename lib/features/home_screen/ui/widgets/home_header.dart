import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_state.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        final firstName = _getFirstName(profileState.name);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: isDark
                  ? Border.all(
                      color: AppColors.darkBorder.withValues(alpha: 0.4),
                      width: 1.w,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: isDark ? 10 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Emoji Avatar
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.primaryLighter.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      _getGreetingEmoji(context),
                      style: TextStyle(fontSize: 22.sp),
                    ),
                  ),
                ),
                horizontalSpace(12),
                // Greeting Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                            height: 1.3.h,
                          ),
                          children: [
                            TextSpan(text: _getGreetingPrefix(context)),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: firstName ?? context.l10n.unknownUser,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.primaryLight
                                    : AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(text: '!'),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      verticalSpace(4),
                      Text(
                        context.l10n.readyToBuildHabits,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                          height: 1.3.h,
                        ),
                      ),
                    ],
                  ),
                ),
                horizontalSpace(8),
                // Status Badge
                BlocBuilder<BillingCubit, BillingState>(
                  builder: (context, billingState) {
                    if (billingState.isPremium) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.amber,
                            width: 1.w,
                          ),
                        ),
                        child: Text(
                          '∞',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                      );
                    }

                    return BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, homeState) {
                        final habitCount = homeState.habits.length;
                        const maxFreeHabits = 5;
                        final isFull = habitCount >= maxFreeHabits;

                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: isFull
                                ? Colors.orange.withValues(alpha: 0.15)
                                : AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isFull
                                  ? Colors.orange
                                  : AppColors.primary.withValues(alpha: 0.3),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            '$habitCount/$maxFreeHabits',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: isFull ? Colors.orange : AppColors.primary,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _getFirstName(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return null;
    return fullName.trim().split(' ').first;
  }

  String _getGreetingPrefix(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return context.l10n.goodMorning('').replaceAll('!', '').trim();
    }
    if (hour < 17) {
      return context.l10n.goodAfternoon('').replaceAll('!', '').trim();
    }
    return context.l10n.goodEvening('').replaceAll('!', '').trim();
  }

  String _getGreetingEmoji(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) return '👋';
    if (hour < 17) return '☀️';
    return '🌙';
  }
}