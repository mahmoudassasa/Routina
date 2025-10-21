import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';

class ForgotPasswordScreenSuccessState extends StatefulWidget {
  const ForgotPasswordScreenSuccessState({super.key});

  @override
  State<ForgotPasswordScreenSuccessState> createState() =>
      _ForgotPasswordScreenSuccessStateState();
}

class _ForgotPasswordScreenSuccessStateState
    extends State<ForgotPasswordScreenSuccessState> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(child: Text('✅', style: TextStyle(fontSize: 32))),
    );
  }
}
