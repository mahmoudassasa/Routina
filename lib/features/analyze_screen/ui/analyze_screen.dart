import 'package:flutter/material.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_ai_analysis_logo.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_mock_ai_features.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_texts.dart';

class AnalyzeScreen extends StatelessWidget {
  const AnalyzeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.backgroundGradientStart,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC), // very light blue
              Color(0xFFE0E7FF), // light indigo
            ],
          ),
        ),
        child: Material(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AI Analysis Icon
                AnalyzeScreenAiAnalysisLogo(),
                const SizedBox(height: 32),
                // Texts
                const AnalyzeScreenTexts(),
                const SizedBox(height: 40),
                // Mock AI Features
                const AnalyzeScreenMockAiFeatures(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
