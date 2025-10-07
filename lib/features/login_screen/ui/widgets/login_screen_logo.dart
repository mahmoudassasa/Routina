import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';

class LoginScreenLogo extends StatelessWidget {
  const LoginScreenLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(child: Text('🎯', style: TextStyle(fontSize: 32))),
    );
  }
}
