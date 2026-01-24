import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/habit_constants.dart';
import 'package:routina/core/widgets/create_habit/ui/create_habit_bottom_sheet.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';

class HabitCard extends StatelessWidget {
  final Map<String, dynamic> habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color habitColor = Color(habit['color'] ?? AppColors.primary.value);
    final IconData iconData = HabitConstants.getIcon(habit['icon'] ?? 'sport');
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
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade700],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 32.sp),
            SizedBox(height: 8.h),
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
                    _buildIconBox(habitColor, iconData),
                    SizedBox(width: 16.w),
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
                          SizedBox(height: 4.h),
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

                SizedBox(height: 24.h),
                _buildProgressBar(context, progress, habitColor, isDark),
                SizedBox(height: 24.h),
                _buildInteractiveWeekStrip(
                  context,
                  frequency,
                  weekProgress,
                  habitColor,
                  isDark,
                ),
                SizedBox(height: 24.h),

                Container(
                  width: double.infinity,
                  height: 58.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    gradient: isActionable
                        ? LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [habitColor, habitColor.withBlue(255)],
                          )
                        : null,
                    color: !isActionable
                        ? (isDark ? Colors.grey[800] : Colors.grey[200])
                        : null,
                    boxShadow: isActionable
                        ? [
                            BoxShadow(
                              color: habitColor.withValues(
                                alpha: isDark ? 0.4 : 0.25,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isActionable
                          ? () => context.read<HomeCubit>().toggleDay(
                              habit['id'],
                              targetIndex,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(18.r),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isActionable
                                  ? Icons.circle_outlined
                                  : (isTodayScheduled
                                        ? Icons.check_circle
                                        : Icons.bedtime_rounded),
                              color: isActionable ? Colors.white : Colors.grey,
                              size: 22.sp,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              isActionable
                                  ? 'Mark as Done'
                                  : (isTodayScheduled
                                        ? 'Completed Today'
                                        : 'Rest Day'),
                              style: TextStyle(
                                color: isActionable
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                                height: 1.1,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
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
              onPressed: () => Navigator.of(context).pop(false),
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
              onPressed: () => Navigator.of(context).pop(true),
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

  Widget _buildProgressBar(
    BuildContext context,
    double progress,
    Color color,
    bool isDark,
  ) {
    final double availableWidth = 1.sw - 80.w;
    final double clampedProgress = progress.clamp(0.0, 1.0);

    return Stack(
      children: [
        Container(
          height: 10.h,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          height: 10.h,
          width: availableWidth * clampedProgress,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveWeekStrip(
    BuildContext context,
    List<bool> frequency,
    List<bool> weekProgress,
    Color color,
    bool isDark,
  ) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        bool isScheduled = frequency[index];
        bool isDone = weekProgress[index];
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                days[index],
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: isScheduled
                      ? (isDark ? Colors.white70 : Colors.grey[800])
                      : Colors.grey[400],
                ),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: isScheduled
                    ? () => context.read<HomeCubit>().toggleDay(
                        habit['id'],
                        index,
                      )
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? color : Colors.transparent,
                    border: isScheduled
                        ? Border.all(
                            color: isDone
                                ? Colors.transparent
                                : (isDark
                                      ? Colors.grey[700]!
                                      : Colors.grey[300]!),
                            width: 1.5.w,
                          )
                        : null,
                  ),
                  child: isDone
                      ? Icon(Icons.check, color: Colors.white, size: 18.sp)
                      : (!isScheduled
                            ? Center(
                                child: Container(
                                  width: 4.w,
                                  height: 4.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildIconBox(Color color, IconData icon) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Icon(icon, color: color, size: 28.sp),
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
