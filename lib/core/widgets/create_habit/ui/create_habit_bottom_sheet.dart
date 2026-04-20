import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/services/notification_service.dart';
import 'package:routina/core/theaming/habit_constants.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/core/widgets/create_habit/ui/widgets/icon_selector.dart';
import 'package:routina/core/widgets/create_habit/ui/widgets/color_picker_widget.dart';
import 'package:routina/core/widgets/create_habit/ui/widgets/frequency_selector.dart';
import 'package:routina/core/widgets/create_habit/ui/widgets/reminder_time_picker_tile.dart';
import 'package:routina/core/widgets/create_habit/ui/widgets/create_habit_action_button.dart';

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
  TimeOfDay? _selectedTime;

  int fastHash(String uuid) => uuid.hashCode.abs();

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
      child: SingleChildScrollView(
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
            verticalSpace(24),
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
            verticalSpace(24),
            IconSelector(
              selectedIconKey: _selectedIconKey,
              selectedColor: _selectedColor,
              onIconSelected: (iconKey) => setState(() => _selectedIconKey = iconKey),
            ),
            verticalSpace(24),
            ColorPickerWidget(
              selectedColor: _selectedColor,
              onColorSelected: (color) => setState(() => _selectedColor = color),
            ),
            verticalSpace(24),
            FrequencySelector(
              selectedDays: _selectedDays,
              selectedColor: _selectedColor,
              onDayToggled: (index) => setState(
                () => _selectedDays[index] = !_selectedDays[index],
              ),
            ),
            verticalSpace(24),
            ReminderTimePickerTile(
              selectedTime: _selectedTime,
              selectedColor: _selectedColor,
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                  helpText: 'Set daily reminder',
                );
                if (picked != null && mounted) {
                  setState(() => _selectedTime = picked);
                }
              },
              onClear: () => setState(() => _selectedTime = null),
            ),
            verticalSpace(24),

            CreateHabitActionButton(
              isEditMode: _isEditMode,
              selectedColor: _selectedColor,
              onPressed: () async {
                if (_titleController.text.trim().isEmpty) return;

                if (_isEditMode) {
                  final homeCubit = context.read<HomeCubit>();
                  final habitTitle = _titleController.text;
                  final habitId = fastHash(
                    widget.habitToEdit!['id'].toString(),
                  );
                  final selectedTime = _selectedTime;

                  homeCubit.updateHabit(
                    habitId: widget.habitToEdit!['id'],
                    title: habitTitle,
                    iconKey: _selectedIconKey,
                    colorValue: _selectedColor.toARGB32(),
                    days: _selectedDays,
                  );

                  if (!mounted) return;

                  context.pop();

                  if (selectedTime != null) {
                    await cancelNotification(habitId);
                    await scheduleDailyNotification(
                      id: habitId,
                      title: 'Routina: Time for $habitTitle! 🚀',
                      body: 'Stay consistent! Time to complete this habit.',
                      hour: selectedTime.hour,
                      minute: selectedTime.minute,
                    );
                  }
                } else {
                  final selectedTime = _selectedTime;
                  final title = _titleController.text.trim();
                  final homeCubit = context.read<HomeCubit>();

                  context.pop();

                  final realId = await homeCubit.addHabit(
                    title: title,
                    iconKey: _selectedIconKey,
                    colorValue: _selectedColor.toARGB32(),
                    days: _selectedDays,
                  );

                  if (selectedTime != null && realId != null) {
                    final habitId = fastHash(realId.toString());
                    await scheduleDailyNotification(
                      id: habitId,
                      title: 'Routina: Time for $title! 🚀',
                      body: 'Stay consistent! Time to complete this habit.',
                      hour: selectedTime.hour,
                      minute: selectedTime.minute,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
