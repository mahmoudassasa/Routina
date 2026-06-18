import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';

class HabitActionButton extends StatelessWidget {
  final bool isActionable;
  final bool isTodayScheduled;
  final Color habitColor;
  final bool isDark;
  final VoidCallback? onPressed;

  const HabitActionButton({
    super.key,
    required this.isActionable,
    required this.isTodayScheduled,
    required this.habitColor,
    required this.isDark,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: isActionable ? habitColor : null,
        boxShadow: isActionable
            ? [
                BoxShadow(
                  color: habitColor.withValues(alpha: isDark ? 0.4 : 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActionable ? onPressed : null,
          borderRadius: BorderRadius.circular(18.r),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isActionable
                      ? Icons.circle_outlined
                      : (isTodayScheduled
                            ? Icons.check_circle
                            : Icons.bedtime_rounded),
                  color: isActionable ? Colors.white : Colors.grey,
                  size: 22.sp,
                ),
                horizontalSpace(12),
                Text(
                  isActionable
                      ? context.l10n.markAsDone
                      : (isTodayScheduled
                            ? context.l10n.completedToday
                            : context.l10n.restDay),
                  style: TextStyle(
                    color: isActionable ? Colors.white : Colors.grey,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    height: 1.1.h,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
