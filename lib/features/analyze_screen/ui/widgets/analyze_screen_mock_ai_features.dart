import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_state.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_ai_analysis_result.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_ai_features_card.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/feature_bottom_sheet.dart'; 

class AnalyzeScreenMockAiFeatures extends StatelessWidget {
  const AnalyzeScreenMockAiFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AiAnalysisCubit, AiAnalysisState>(
      listenWhen: (previous, current) => current.status != AiAnalysisStatus.initial,
      listener: (context, state) {
        AnalyzeScreenAiAnalysisResult.showAnalysisSheet(context, state);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          children: [
            AIFeatureCard(
              icon: '✨',
              title: 'Overall Analysis',
              description: 'Get a full AI breakdown of your routine',
              onTap: () {
                final habits = context.read<HomeCubit>().state.habits;
                if (habits.isNotEmpty) {
                  context.read<AiAnalysisCubit>().analyzeHabits(habits);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add some habits first!')),
                  );
                }
              },
            ),
            verticalSpace(16), 

            AIFeatureCard(
              icon: '💡',
              title: 'Smart Suggestions',
              description: 'Personalized tips to improve your habits',
              onTap: () => showPremiumFeatureBottomSheet(
                context: context,
                icon: '💡',
                title: 'Smart AI Suggestions',
                description: 'Our AI will analyze your patterns to give you tailored advice.',
                features: ['Habit stacking strategies', 'Best performing hours', 'Routine optimization'],
              ),
            ),
            verticalSpace(16), 

            AIFeatureCard(
              icon: '🎯',
              title: 'Goal Optimization',
              description: 'AI-powered recommendations for better results',
              onTap: () => showPremiumFeatureBottomSheet(
                context: context,
                icon: '🎯',
                title: 'Goal Optimization',
                description: 'Let Gemini AI help you set smarter, more achievable goals.',
                features: ['Success forecasting', 'Dynamic difficulty', 'Milestone breakdown'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}