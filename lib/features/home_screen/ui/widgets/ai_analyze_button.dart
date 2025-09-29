import 'package:flutter/material.dart';

class AiAnalyzeButton extends StatefulWidget {
  const AiAnalyzeButton({super.key});

  @override
  State<AiAnalyzeButton> createState() => _AiAnalyzeButtonState();
}

class _AiAnalyzeButtonState extends State<AiAnalyzeButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {
              // Navigate to analyze tab
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🤖 AI Analysis coming soon!'),
                  backgroundColor: Color(0xFF3B82F6),
                ),
              );
            },
            child: const Center(
              child: Text('🤖', style: TextStyle(fontSize: 32)),
            ),
          ),
        ),
      ),
    );
  }
}
