import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';

class HabitWeekStrip extends StatelessWidget {
  final List<bool> frequency;
  final List<bool> weekProgress;
  final Color color;
  final bool isDark;
  final dynamic habitId;

  const HabitWeekStrip({
    super.key,
    required this.frequency,
    required this.weekProgress,
    required this.color,
    required this.isDark,
    required this.habitId,
  });

  @override
  Widget build(BuildContext context) {
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
              verticalSpace(10),
              GestureDetector(
                onTap: isScheduled
                    ? () => context.read<HomeCubit>().toggleDay(
                        habitId,
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
}