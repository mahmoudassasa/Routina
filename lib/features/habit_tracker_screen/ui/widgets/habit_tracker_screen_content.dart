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
                    context.l10n.trackYourGrowth,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  verticalSpace(8),
                  Text(
                    context.l10n.trackYourGrowthDesc,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      height: 1.4.h,
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
                    title: context.l10n.progressCharts,
                    description: context.l10n.progressChartsDesc,
                    onTap: () {
                      final habitsList = context.read<HomeCubit>().state.habits;

                      context.pushNamed(
                        Routes.habitProgressChartsScreen,
                        arguments: habitsList,
                      );
                    },
                  ),

                  verticalSpace(16),

                  FeaturePreviewCard(
                    icon: '🎯',
                    title: context.l10n.strategicGoalsCard,
                    description: context.l10n.strategicGoalsCardDesc,
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
                          title: context.l10n.smartGoalTracking,
                          description: context.l10n.smartGoalTrackingDesc,
                          features: [
                            context.l10n.multiStageGoalMilestones,
                            context.l10n.predictiveStreakCounting,
                            context.l10n.customSuccessCriteria,
                          ],
                        );
                      }
                    },
                  ),

                  verticalSpace(16),

                  FeaturePreviewCard(
                    icon: '💎',
                    title: context.l10n.premiumAnalytics,
                    description: context.l10n.premiumAnalyticsDesc,
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
                          title: context.l10n.eliteInsightsTitle,
                          description: context.l10n.eliteInsightsDesc,
                          features: [
                            context.l10n.behavioralPatternRecognition,
                            context.l10n.smartTimeOfDaySuggestions,
                            context.l10n.priorityHabitFocus,
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