import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/habit_constants.dart';

class ColorPickerWidget extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.colorLabel,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        verticalSpace(12),
        SizedBox(
          height: 45.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: HabitConstants.presetColors.length,
            itemBuilder: (context, index) {
              final color = HabitConstants.presetColors[index];
              final isSelected = selectedColor == color;
              final isLightColor = color.computeLuminance() > 0.7;

              return GestureDetector(
                onTap: () => onColorSelected(color),
                child: Container(
                  width: 38.w,
                  height: 38.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? (isDark ? Colors.white : Colors.black)
                          : (isLightColor && !isDark
                                ? Colors.grey.withValues(alpha: 0.3)
                                : Colors.transparent),
                      width: isSelected ? 2.w : 1.w,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: isLightColor ? Colors.black : Colors.white,
                          size: 20.sp,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}