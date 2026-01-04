import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';

class AnalyzeScreenAiAnalysisLogo extends StatelessWidget {
  const AnalyzeScreenAiAnalysisLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            Color(0xFF60A5FA), // Accent blue
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.5 : 0.3),
            blurRadius: 40, // Increased blur for a "glow" effect
            offset: const Offset(0, 10),
          ),
          if (isDark)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.1),
              blurRadius: 2,
              spreadRadius: -2,
            ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: const Center(
        child: Text(
          '🤖',
          style: TextStyle(fontSize: 56), // Slightly larger for impact
        ),
      ),
    );
  }
}