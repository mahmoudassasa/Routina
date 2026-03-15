import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_state.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_ai_analysis_logo.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_ai_analysis_result.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_mock_ai_features.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_texts.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkBackgroundGradientStart,
                  AppColors.darkBackgroundGradientEnd,
                ]
              : [
                  AppColors.backgroundGradientStart,
                  AppColors.backgroundGradientEnd,
                ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocBuilder<AiAnalysisCubit, AiAnalysisState>(
            builder: (context, state) {
              final habits = context.read<HomeCubit>().state.habits;

              if (habits.isEmpty) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        AnalyzeScreenAiAnalysisLogo(),
                        SizedBox(height: 32),
                        AnalyzeScreenTexts(),
                        SizedBox(height: 40),
                        AnalyzeScreenMockAiFeatures(),
                      ],
                    ),
                  ),
                );
              }

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AnalyzeScreenAiAnalysisLogo(),
                      const SizedBox(height: 32),
                      const AnalyzeScreenTexts(),
                      const SizedBox(height: 40),
                      AnalyzeScreenAiAnalysisResult(state: state),
                      const SizedBox(height: 24),
                      const AnalyzeScreenMockAiFeatures(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


