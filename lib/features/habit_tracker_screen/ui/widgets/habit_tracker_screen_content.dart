import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/feature_bottom_sheet.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/feature_preview_card.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';

class HabitTrackerScreenContent extends StatelessWidget {
  const HabitTrackerScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            verticalSpace(32),

            Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                    blurRadius: 20.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: Center(
                child: Text('📈', style: TextStyle(fontSize: 45.sp)),
              ),
            ),

            verticalSpace(24),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                children: [
                  Text(
                    'Track Your Growth',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  verticalSpace(8),
                  Text(
                    'Visualize your progress and unlock deep insights into your daily habits.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            verticalSpace(40),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  FeaturePreviewCard(
                    icon: '📊',
                    title: 'Progress Charts',
                    description:
                        'Interactive weekly and monthly visualizations',
                    onTap: () {
                      final habitsList = context.read<HomeCubit>().state.habits;

                      context.pushNamed(
                        Routes.habitProgressChartsScreen,
                        arguments: habitsList,
                      );
                    },
                  ),

                  verticalSpace(16),
                  // Strategic Goals
                  FeaturePreviewCard(
                    icon: '🎯',
                    title: 'Strategic Goals',
                    description: 'Set milestones and track achievements',
                    // Strategic Goals
                    onTap: () {
                      final isPremium = context
                          .read<BillingCubit>()
                          .state
                          .isPremium;
                      if (isPremium) {
                        final habits = context.read<HomeCubit>().state.habits;
                        context.pushNamed(
                          Routes.strategicGoalsScreen,
                          arguments: habits,
                        );
                      } else {
                        showPremiumFeatureBottomSheet(
                          context: context,
                          icon: '🎯',
                          title: 'Smart Goal Tracking',
                          description:
                              'Go beyond daily tasks and start building long-term streaks with AI guidance.',
                          features: [
                            'Multi-stage goal milestones',
                            'Predictive streak counting',
                            'Custom success criteria',
                          ],
                        );
                      }
                    },
                  ),

                  verticalSpace(16),

                  // Premium Analytics
                  FeaturePreviewCard(
                    icon: '💎',
                    title: 'Premium Analytics',
                    description: 'Advanced data for power users',
                    // Premium Analytics
                    onTap: () {
                      final isPremium = context
                          .read<BillingCubit>()
                          .state
                          .isPremium;
                      if (isPremium) {
                        final habits = context.read<HomeCubit>().state.habits;
                        context.pushNamed(
                          Routes.premiumAnalyticsScreen,
                          arguments: habits,
                        );
                      } else {
                        showPremiumFeatureBottomSheet(
                          context: context,
                          icon: '💎',
                          title: 'Elite Insights',
                          description:
                              'Unlock the full power of your data with our most advanced tracking engine.',
                          features: [
                            'Behavioral pattern recognition',
                            'Smart time-of-day suggestions',
                            'Priority habit focus',
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            verticalSpace(40),
          ],
        ),
      ),
    );
  }
}
