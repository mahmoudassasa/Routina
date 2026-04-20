import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/widgets/create_habit/ui/create_habit_bottom_sheet.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/ui/widgets/habit_icon_box.dart';
import 'package:routina/features/home_screen/ui/widgets/habit_progress_bar.dart';
import 'package:routina/features/home_screen/ui/widgets/habit_week_strip.dart';
import 'package:routina/features/home_screen/ui/widgets/habit_action_button.dart';

class HabitCard extends StatelessWidget {
  final Map<String, dynamic> habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color habitColor = Color(
      habit['color'] ?? AppColors.primary.toARGB32,
    );
    final double progress = (habit['progress'] ?? 0.0).toDouble();

    final List<bool> frequency = List<bool>.from(
      habit['frequency'] ?? List.filled(7, true),
    );
    final List<bool> weekProgress = List<bool>.from(
      habit['weekProgress'] ?? List.filled(7, false),
    );

    final int todayIndex = DateTime.now().weekday - 1;

    int targetIndex = -1;
    if (frequency[todayIndex] && !weekProgress[todayIndex]) {
      targetIndex = todayIndex;
    } else {
      for (int i = 0; i < 7; i++) {
        if (frequency[i] && !weekProgress[i]) {
          targetIndex = i;
          break;
        }
      }
    }

    final bool isActionable = targetIndex != -1;
    final bool isTodayScheduled = frequency[todayIndex];

    return Dismissible(
      key: Key(habit['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(24.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 32.sp),
            verticalSpace(8),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(context, habit['title']);
      },
      onDismissed: (direction) {
        context.read<HomeCubit>().deleteHabit(habit['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${habit['title']} deleted'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
        child: Card(
          color: isDark ? AppColors.darkSurface : Colors.white,
          elevation: isDark ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
            side: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.shade100,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Row(
                  children: [
                    HabitIconBox(
                      habitColor: habitColor,
                      iconKey: habit['icon'] ?? 'sport',
                    ),
                    horizontalSpace(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit['title'],
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          verticalSpace(2), 
                          Text(
                            "${(progress * 100).toInt()}% Weekly Goal",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showEditBottomSheet(context),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        size: 22.sp,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                verticalSpace(24), 
                HabitProgressBar(
                  progress: progress,
                  color: habitColor,
                  isDark: isDark,
                ),
                verticalSpace(24), 
                HabitWeekStrip(
                  frequency: frequency,
                  weekProgress: weekProgress,
                  color: habitColor,
                  isDark: isDark,
                  habitId: habit['id'],
                ),
                verticalSpace(24), 

                HabitActionButton(
                  isActionable: isActionable,
                  isTodayScheduled: isTodayScheduled,
                  habitColor: habitColor,
                  isDark: isDark,
                  onPressed: () => context.read<HomeCubit>().toggleDay(
                      habit['id'],
                      targetIndex,
                    ),
                ),
            
            
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(
    BuildContext context,
    String habitTitle,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1A1C23) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Delete Habit?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "$habitTitle"? This action cannot be undone.',
            style: TextStyle(
              fontSize: 15.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: homeCubit,
        child: CreateHabitBottomSheet(habitToEdit: habit),
      ),
    );
  }
}
