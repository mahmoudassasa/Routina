import 'package:flutter/material.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_ai_analysis_logo.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_mock_ai_features.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_texts.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: SingleChildScrollView(
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
