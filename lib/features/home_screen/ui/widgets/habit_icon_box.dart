import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/habit_constants.dart';

class HabitIconBox extends StatelessWidget {
  final Color habitColor;
  final String iconKey;

  const HabitIconBox({
    super.key,
    required this.habitColor,
    required this.iconKey,
  });

  @override
  Widget build(BuildContext context) {
    final IconData iconData = HabitConstants.getIcon(iconKey);

    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: habitColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Icon(iconData, color: habitColor, size: 28.sp),
    );
  }
}