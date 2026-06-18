import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HabitProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final bool isDark;

  const HabitProgressBar({
    super.key,
    required this.progress,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final double availableWidth = (1.0.sw) - (80.w);
    final double clampedProgress = progress.clamp(0.0, 1.0);

    return Stack(
      children: [
        Container(
          height: 10.h,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          height: 10.h,
          width: availableWidth * clampedProgress,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
