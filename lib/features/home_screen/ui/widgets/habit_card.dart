import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/habit_constants.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart'; // Check path

class HabitCard extends StatelessWidget {
  final Map<String, dynamic> habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Extract Data
    final Color habitColor = Color(habit['color'] ?? AppColors.primary.value);
    final IconData iconData = HabitConstants.getIcon(habit['icon'] ?? 'sport');
    final double progress = habit['progress'] ?? 0.0;
    
    // Lists should be retrieved safely
    final List<bool> frequency = List<bool>.from(habit['frequency'] ?? List.filled(7, true));
    final List<bool> weekProgress = List<bool>.from(habit['weekProgress'] ?? List.filled(7, false));

    // Determine if "Today" is completed (For the big button)
    // For demo: Let's assume the last day (index 6) is "Today". 
    // In real app, we use DateTime.now().weekday
    final bool isTodayCompleted = weekProgress.last; 

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Card(
        color: isDark ? AppColors.darkSurface : Colors.white,
        elevation: isDark ? 0 : 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(color: isDark ? Colors.transparent : Colors.grey.shade100),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // 1. Header (Icon + Title + Percentage)
              Row(
                children: [
                  _buildIconBox(habitColor, iconData),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit['title'],
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        // Dynamic Progress Text
                        Text(
                          "${(progress * 100).toInt()}% Weekly Goal",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20.h),
              
              // 2. Progress Bar (Linked to Days)
              Stack(
                children: [
                  Container(
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 8.h,
                    width: (MediaQuery.of(context).size.width - 64.w) * progress,
                    decoration: BoxDecoration(
                      color: habitColor,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: habitColor.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),
              
              // 3. Interactive Week Strip
              _buildInteractiveWeekStrip(context, frequency, weekProgress, habitColor, isDark),
              
              SizedBox(height: 20.h),

              // 4. Main Action Button (Themed)
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Toggle "Today" (Assuming index 6 is today)
                    context.read<HomeCubit>().toggleDay(habit['id'], 6);
                  },
                  icon: Icon(
                    isTodayCompleted ? Icons.check_circle : Icons.circle_outlined,
                    color: isTodayCompleted ? Colors.white : habitColor,
                  ),
                  label: Text(
                    isTodayCompleted ? 'Completed Today' : 'Mark as Done',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isTodayCompleted ? Colors.white : habitColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    // IF Done: Solid Habit Color. IF Not Done: Light Background with Habit Color Text
                    backgroundColor: isTodayCompleted ? habitColor : habitColor.withOpacity(0.1),
                    elevation: isTodayCompleted ? 2 : 0,
                    shadowColor: habitColor.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBox(Color color, IconData icon) {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Icon(icon, color: color, size: 24.sp),
    );
  }

  Widget _buildInteractiveWeekStrip(
    BuildContext context, 
    List<bool> frequency, 
    List<bool> weekProgress, 
    Color color, 
    bool isDark
  ) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        // Is this day part of the plan?
        bool isScheduled = frequency[index]; 
        // Is this day actually done?
        bool isDone = weekProgress[index];

        return GestureDetector(
          onTap: () {
            if (isScheduled) {
              // Trigger Logic via Cubit
              context.read<HomeCubit>().toggleDay(habit['id'], index);
            }
          },
          child: Column(
            children: [
              Text(
                days[index],
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: isScheduled 
                      ? (isDark ? Colors.white70 : Colors.grey[700]) 
                      : Colors.grey[400], // Dimmed if not scheduled
                ),
              ),
              SizedBox(height: 8.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Logic for Colors:
                  // 1. If Done: Solid Color
                  // 2. If Scheduled but not done: Transparent with Border
                  // 3. If Not Scheduled: Very light grey dot (hidden or small)
                  color: isDone 
                      ? color 
                      : (isScheduled ? Colors.transparent : Colors.transparent),
                  border: isScheduled 
                      ? Border.all(
                          color: isDone ? Colors.transparent : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                          width: 1.5,
                        )
                      : null,
                ),
                child: isDone
                    ? Icon(Icons.check, color: Colors.white, size: 18.sp)
                    : (isScheduled ? null : Center(child: Container(width: 4.w, height: 4.w, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)))),
              ),
            ],
          ),
        );
      }),
    );
  }
}