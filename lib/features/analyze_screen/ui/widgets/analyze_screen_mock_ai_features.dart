import 'package:flutter/material.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_ai_features_card.dart';

class AnalyzeScreenMockAiFeatures extends StatefulWidget {
  const AnalyzeScreenMockAiFeatures({super.key});

  @override
  State<AnalyzeScreenMockAiFeatures> createState() =>
      _AnalyzeScreenMockAiFeaturesState();
}

class _AnalyzeScreenMockAiFeaturesState
    extends State<AnalyzeScreenMockAiFeatures> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          AIFeatureCard(
            icon: '📊',
            title: 'Progress Analysis',
            description: 'Detailed breakdown of your habit performance',
          ),

          const SizedBox(height: 16),

          AIFeatureCard(
            icon: '💡',
            title: 'Smart Suggestions',
            description: 'Personalized tips to improve your habits',
          ),

          const SizedBox(height: 16),

          AIFeatureCard(
            icon: '🎯',
            title: 'Goal Optimization',
            description: 'AI-powered recommendations for better results',
          ),
        ],
      ),
    );
  }
}
