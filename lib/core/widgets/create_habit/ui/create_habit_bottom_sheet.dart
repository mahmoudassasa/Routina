import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/habit_constants.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart'; // تأكد من المسار


class CreateHabitBottomSheet extends StatefulWidget {
  const CreateHabitBottomSheet({super.key});

  @override
  State<CreateHabitBottomSheet> createState() => _CreateHabitBottomSheetState();
}

class _CreateHabitBottomSheetState extends State<CreateHabitBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  String _selectedIconKey = 'sport';
  Color _selectedColor = HabitConstants.presetColors[0];
  
  // 1. حالة أيام الأسبوع (بتبدأ مفعلة كلها)
  final List<String> _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<bool> _selectedDays = List.generate(7, (index) => true);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.9.sh),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ... (نفس كود الـ Header والـ TextField اللي فات) ...
            // اختصاراً للمساحة هبدأ من الجديد
             Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text("New Habit", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)),
            SizedBox(height: 24.h),
            
            // Name Input
             Text("NAME", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, letterSpacing: 1.2)),
            SizedBox(height: 8.h),
            TextField(
              controller: _titleController,
              autofocus: true,
              style: TextStyle(fontSize: 16.sp, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: "e.g., Read 10 pages",
                filled: true,
                fillColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: _selectedColor, width: 1.5)),
              ),
            ),
            SizedBox(height: 24.h),

            // --- الجديد هنا ---
            // 2. Frequency (Days Selector)
            Text(
              "FREQUENCY",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final isSelected = _selectedDays[index];
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedDays[index] = !_selectedDays[index];
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: isSelected ? _selectedColor : (isDark ? AppColors.darkBackground : AppColors.backgroundLight),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.transparent : (isDark ? AppColors.darkBorder : AppColors.border),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _weekDays[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 24.h),

            // Icon Picker (نفس الكود السابق)
             Text("ICON", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, letterSpacing: 1.2)),
            SizedBox(height: 12.h),
            SizedBox(
              height: 60.w,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: HabitConstants.iconsMap.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final key = HabitConstants.iconsMap.keys.elementAt(index);
                  final iconData = HabitConstants.iconsMap.values.elementAt(index);
                  final isSelected = _selectedIconKey == key;
                  return GestureDetector(
                    onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedIconKey = key); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60.w, height: 60.w,
                      decoration: BoxDecoration(
                        color: isSelected ? _selectedColor.withOpacity(0.2) : (isDark ? AppColors.darkBackground : AppColors.backgroundLight),
                        borderRadius: BorderRadius.circular(16.r),
                        border: isSelected ? Border.all(color: _selectedColor, width: 2) : null,
                      ),
                      child: Icon(iconData, color: isSelected ? _selectedColor : Colors.grey[400], size: 28.sp),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),

            // Color Picker (نفس الكود السابق)
             Text("COLOR", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, letterSpacing: 1.2)),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 12.w, runSpacing: 12.h,
              children: HabitConstants.presetColors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedColor = color); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40.w, height: 40.w,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: isSelected ? Border.all(color: isDark ? Colors.white : Colors.black, width: 3) : null),
                    child: isSelected ? Icon(Icons.check, color: Colors.white, size: 20.sp) : null,
                  ),
                );
              }).toList(),
            ),
            
            SizedBox(height: 32.h),

            // 3. Create Button (مع اللوجيك الحقيقي)
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
              // Inside onPressed of the Create Button:

onPressed: () {
  if (_titleController.text.trim().isEmpty) {
    // Show error for title
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a habit name')),
    );
    return;
  }

  // VALIDATION: Check if at least one day is selected
  if (!_selectedDays.contains(true)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select at least one day')),
    );
    return;
  }

  context.read<HomeCubit>().addHabit(
    title: _titleController.text,
    iconKey: _selectedIconKey,
    colorValue: _selectedColor.value,
    days: _selectedDays,
  );

  context.pop();
},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                ),
                child: Text("Create Habit", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}