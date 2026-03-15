import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/habit_constants.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';

class CreateHabitBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? habitToEdit;

  const CreateHabitBottomSheet({super.key, this.habitToEdit});

  @override
  State<CreateHabitBottomSheet> createState() => _CreateHabitBottomSheetState();
}

class _CreateHabitBottomSheetState extends State<CreateHabitBottomSheet> {
  late final TextEditingController _titleController;
  late String _selectedIconKey;
  late Color _selectedColor;
  late final List<bool> _selectedDays;
  late final bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.habitToEdit != null;

    if (_isEditMode) {
      final habit = widget.habitToEdit!;
      _titleController = TextEditingController(text: habit['title'] ?? '');
      _selectedIconKey = habit['icon'] ?? 'sport';
      _selectedColor = Color(
        habit['color'] ?? HabitConstants.presetColors[0].toARGB32(),
      );
      _selectedDays = List<bool>.from(
        habit['frequency'] ?? List.filled(7, true),
      );
    } else {
      _titleController = TextEditingController();
      _selectedIconKey = 'sport';
      _selectedColor = HabitConstants.presetColors[0];
      _selectedDays = List.generate(7, (index) => true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
        left: 24.w,
        right: 24.w,
        top: 16.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1C23) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          TextField(
            controller: _titleController,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'Habit Title',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15.sp),
              filled: true,
              fillColor: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          Text(
            "Icon",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 54.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: HabitConstants.iconsMap.entries.map((entry) {
                final isSelected = _selectedIconKey == entry.key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIconKey = entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: 12.w),
                    width: 54.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _selectedColor
                          : _selectedColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      entry.value,
                      color: isSelected ? Colors.white : _selectedColor,
                      size: 24.sp,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 24.h),

          Text(
  "Color",
  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
),
SizedBox(height: 12.h),
SizedBox(
  height: 45.h,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    itemCount: HabitConstants.presetColors.length,
    itemBuilder: (context, index) {
      final color = HabitConstants.presetColors[index];
      final isSelected = _selectedColor == color;
      
      final isLightColor = color.computeLuminance() > 0.7;
      
      return GestureDetector(
        onTap: () => setState(() => _selectedColor = color),
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
          SizedBox(height: 24.h),

          Text(
            "Frequency",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              final isSelected = _selectedDays[index];
              return GestureDetector(
                onTap: () => setState(
                  () => _selectedDays[index] = !_selectedDays[index],
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: isSelected ? _selectedColor : Colors.transparent,
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
          SizedBox(height: 32.h),

          Container(
            width: double.infinity,
            height: 58.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  _selectedColor,
                  _selectedColor.withBlue(255).withValues(alpha: 0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _selectedColor.withValues(alpha: isDark ? 0.4 : 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (_titleController.text.trim().isNotEmpty) {
                    if (_isEditMode) {
                      context.read<HomeCubit>().updateHabit(
                        habitId: widget.habitToEdit!['id'],
                        title: _titleController.text,
                        iconKey: _selectedIconKey,
                        colorValue: _selectedColor.toARGB32(),
                        days: _selectedDays,
                      );
                    } else {
                      context.read<HomeCubit>().addHabit(
                        title: _titleController.text,
                        iconKey: _selectedIconKey,
                        colorValue: _selectedColor.toARGB32(),
                        days: _selectedDays,
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                borderRadius: BorderRadius.circular(18.r),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isEditMode ? Icons.save_rounded : Icons.add_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _isEditMode ? 'Save Changes' : 'Create Habit',
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
          ),
        ],
      ),
    );
  }
}