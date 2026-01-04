import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_ai_analysis_logo.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_mock_ai_features.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_texts.dart';

class AnalyzeScreen extends StatelessWidget {
  const AnalyzeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkBackgroundGradientStart, AppColors.darkBackgroundGradientEnd]
              : [AppColors.backgroundGradientStart, AppColors.backgroundGradientEnd],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // لجعل الجرادينت يظهر
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AnalyzeScreenAiAnalysisLogo(),
                  const SizedBox(height: 32),
                  const AnalyzeScreenTexts(),
                  const SizedBox(height: 40),
                  const AnalyzeScreenMockAiFeatures(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}