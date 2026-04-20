import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/habit_constants.dart';

class IconSelector extends StatelessWidget {
  final String selectedIconKey;
  final Color selectedColor;
  final ValueChanged<String> onIconSelected;

  const IconSelector({
    super.key,
    required this.selectedIconKey,
    required this.selectedColor,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Icon",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        verticalSpace(12),
        SizedBox(
          height: 54.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: HabitConstants.iconsMap.entries.map((entry) {
              final isSelected = selectedIconKey == entry.key;
              return GestureDetector(
                onTap: () => onIconSelected(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 12.w),
                  width: 54.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedColor
                        : selectedColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    entry.value,
                    color: isSelected ? Colors.white : selectedColor,
                    size: 24.sp,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}