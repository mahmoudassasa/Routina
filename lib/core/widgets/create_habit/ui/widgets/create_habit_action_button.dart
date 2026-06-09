import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';

class CreateHabitActionButton extends StatelessWidget {
  final bool isEditMode;
  final Color selectedColor;
  final VoidCallback onPressed;

  const CreateHabitActionButton({
    super.key,
    required this.isEditMode,
    required this.selectedColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 58.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: selectedColor,
        boxShadow: [
          BoxShadow(
            color: selectedColor.withValues(
              alpha: isDark ? 0.4 : 0.25,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18.r),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isEditMode ? Icons.save_rounded : Icons.add_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
                horizontalSpace(8),
                Text(
                    isEditMode ? context.l10n.saveChanges : context.l10n.createHabit,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    height: 1.1,
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