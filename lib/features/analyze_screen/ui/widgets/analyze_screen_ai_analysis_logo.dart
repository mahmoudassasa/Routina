import 'package:flutter/material.dart';

class AnalyzeScreenAiAnalysisLogo extends StatelessWidget {
  const AnalyzeScreenAiAnalysisLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: const Center(child: Text('🤖', style: TextStyle(fontSize: 48))),
    );
  }
}
