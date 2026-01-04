import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';

class ForgotPasswordScreenSuccessState extends StatelessWidget {
  const ForgotPasswordScreenSuccessState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 100.w, // Slightly larger for a better brand feel
      height: 100.w,
      decoration: BoxDecoration(
        // In dark mode, we use a deep green or a subtle primary tint
        color: isDark 
            ? Colors.greenAccent.withValues(alpha: 0.1) 
            : AppColors.successLight,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark 
              ? Colors.greenAccent.withValues(alpha: 0.2) 
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.greenAccent : AppColors.success)
                .withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.check_circle_rounded,
          size: 50.sp,
          color: isDark ? Colors.greenAccent : AppColors.success,
        ),
      ),
    );
  }
}