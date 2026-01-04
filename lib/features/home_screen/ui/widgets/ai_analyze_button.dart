import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';

class AiAnalyzeButton extends StatelessWidget {
  const AiAnalyzeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Tooltip(
        message: 'AI Analysis',
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                Color(0xFF60A5FA), // Lighter blue for a glow effect
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🤖 AI Analysis coming soon!'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Center(
                child: Text(
                  '🤖',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}