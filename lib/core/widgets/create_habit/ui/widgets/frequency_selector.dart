import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';

class FrequencySelector extends StatelessWidget {
  final List<bool> selectedDays;
  final Color selectedColor;
  final ValueChanged<int> onDayToggled;

  const FrequencySelector({
    super.key,
    required this.selectedDays,
    required this.selectedColor,
    required this.onDayToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Frequency",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        verticalSpace(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
            final isSelected = selectedDays[index];
            return GestureDetector(
              onTap: () => onDayToggled(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isSelected ? selectedColor : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.grey.withValues(alpha: 0.5),
                    width: 1.5.w,
                  ),
                ),
                child: Center(
                  child: Text(
                    days[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}