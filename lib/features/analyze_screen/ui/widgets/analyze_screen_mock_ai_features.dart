import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_cubit.dart';
import 'package:routina/features/analyze_screen/ui/widgets/ai_analysis_goal_optimization_screen.dart';
import 'package:routina/features/analyze_screen/ui/widgets/ai_analysis_smart_suggestions_screen.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_ai_features_card.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/feature_bottom_sheet.dart';

class AnalyzeScreenMockAiFeatures extends StatelessWidget {
  const AnalyzeScreenMockAiFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          AIFeatureCard(
            icon: '✨',
            title: context.l10n.overallAnalysis,
            description: context.l10n.overallAnalysisDesc,
            onTap: () {
              final habits = context.read<HomeCubit>().state.habits;
              if (habits.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add some habits first!')),
                );
                return;
              }
              context.read<AiAnalysisCubit>().analyzeHabits(habits);
              context.pushNamed(
                Routes.aiAnalysisFullScreen,
                arguments: {
                  'aiCubit': context.read<AiAnalysisCubit>(),
                  'homeCubit': context.read<HomeCubit>(),
                },
              );
            },
          ),
          verticalSpace(16),
          AIFeatureCard(
            icon: '💡',
            title: context.l10n.smartSuggestions,
            description: context.l10n.smartSuggestionsDesc,
            onTap: () {
              final isPremium = context.read<BillingCubit>().state.isPremium;
              if (isPremium) {
                final habits = context.read<HomeCubit>().state.habits;
                context.push(SmartSuggestionsScreen(habits: habits));
              } else {
                showPremiumFeatureBottomSheet(
                  context: context,
                  icon: '💡',
                  title: context.l10n.smartAiSuggestions,
                  description: context.l10n.smartAiSuggestionsDesc,
                  features: [
                    context.l10n.habitStacking,
                    context.l10n.bestPerformingHours,
                    context.l10n.routineOptimization,
                  ],
                );
              }
            },
          ),
          verticalSpace(16),

          // Goal Optimization
          AIFeatureCard(
            icon: '🎯',
            title: context.l10n.goalOptimization,
            description: context.l10n.goalOptimizationDesc,
            onTap: () {
              final isPremium = context.read<BillingCubit>().state.isPremium;
              if (isPremium) {
                final habits = context.read<HomeCubit>().state.habits;
                context.push(GoalOptimizationScreen(habits: habits));
              } else {
                showPremiumFeatureBottomSheet(
                  context: context,
                  icon: '🎯',
                  title: context.l10n.goalOptimizationTitle,
                  description: context.l10n.goalOptimizationDesc2,
                  features: [
                    context.l10n.successForecasting,
                    context.l10n.dynamicDifficulty,
                    context.l10n.milestoneBreakdown,
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
