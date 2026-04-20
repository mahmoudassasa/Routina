import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';

class ReminderTimePickerTile extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final Color selectedColor;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const ReminderTimePickerTile({
    super.key,
    required this.selectedTime,
    required this.selectedColor,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: selectedTime != null
              ? selectedColor.withValues(alpha: 0.1)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey[100]),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selectedTime != null
                ? selectedColor.withValues(alpha: 0.4)
                : Colors.grey.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selectedTime != null
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_none_rounded,
              color: selectedTime != null
                  ? selectedColor
                  : Colors.grey,
              size: 22.sp,
            ),
            horizontalSpace(12),
            Expanded(
              child: Text(
                selectedTime != null
                    ? 'Reminder at ${selectedTime!.format(context)}'
                    : 'Set a reminder (optional)',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: selectedTime != null
                      ? selectedColor
                      : Colors.grey,
                  fontWeight: selectedTime != null
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            if (selectedTime != null && onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.grey,
                  size: 18.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}