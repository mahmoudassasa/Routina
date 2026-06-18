import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/widgets/ad_banner_widget.dart';
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
  void dispose() {
    super.dispose();
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
        bottomNavigationBar: const AdBannerWidget(),
        body: SafeArea(
          child: BlocBuilder<AiAnalysisCubit, AiAnalysisState>(
            builder: (context, state) {
              final habits = context.read<HomeCubit>().state.habits;
              final content = habits.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnalyzeScreenAiAnalysisLogo(),
                        verticalSpace(32),
                        AnalyzeScreenTexts(),
                        verticalSpace(40),
                        AnalyzeScreenMockAiFeatures(),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AnalyzeScreenAiAnalysisLogo(),
                        verticalSpace(32),
                        const AnalyzeScreenTexts(),
                        verticalSpace(40),
                        AnalyzeScreenAiAnalysisResult(state: state),
                        verticalSpace(24),
                        const AnalyzeScreenMockAiFeatures(),
                      ],
                    );
              return RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                onRefresh: () async {
                  if (habits.isNotEmpty) {
                    context.read<AiAnalysisCubit>().analyzeHabits(habits);
                    await context.read<AiAnalysisCubit>().stream.firstWhere(
                      (s) => s.status != AiAnalysisStatus.loading,
                    );
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: content),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
