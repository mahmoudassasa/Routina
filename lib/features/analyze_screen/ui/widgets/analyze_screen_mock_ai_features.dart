import 'package:flutter/material.dart';
import 'package:routina/features/analyze_screen/ui/widgets/analyze_screen_ai_features_card.dart';

class AnalyzeScreenMockAiFeatures extends StatelessWidget {
  const AnalyzeScreenMockAiFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          AIFeatureCard(
            icon: '📊',
            title: 'Progress Analysis',
            description: 'Detailed breakdown of your habit performance',
          ),
          SizedBox(height: 16),
          AIFeatureCard(
            icon: '💡',
            title: 'Smart Suggestions',
            description: 'Personalized tips to improve your habits',
          ),
          SizedBox(height: 16),
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