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

part 'dismissible_background.dart';
part 'delete_confirmation_dialog.dart';
part 'edit_bottom_sheet.dart';

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
      background: _buildDismissibleBackground (context),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(context, habit['title']);
      },
      onDismissed: (direction) {
        context.read<HomeCubit>().deleteHabit(habit['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.habitDeleted(habit['title'])),
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
                            context.l10n.weeklyGoal((progress * 100).toInt()),
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
}
