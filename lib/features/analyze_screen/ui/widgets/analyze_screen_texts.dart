import 'package:flutter/material.dart';

class AnalyzeScreenTexts extends StatelessWidget {
  const AnalyzeScreenTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'AI Analysis',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Get personalized insights and recommendations based on your habit patterns and progress.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
