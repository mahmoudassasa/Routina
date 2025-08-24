import 'package:flutter/material.dart';
import '../../../../core/helpers/app_constants.dart';

class HabitCardWidget extends StatelessWidget {
  final IconData icon;
  final String name;
  final List<int> weeklyProgress;
  final bool completedToday;
  
  const HabitCardWidget({
    super.key,
    required this.icon,
    required this.name,
    required this.weeklyProgress,
    required this.completedToday,
  });
  
  @override
  Widget build(BuildContext context) {
    final totalCompleted = weeklyProgress.where((day) => day == 1).length;
    final progressPercentage = (totalCompleted / 7) * 100;
    
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Card(
      elevation: 2,
      shadowColor: AppColors.blue500.withValues(alpha:0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Column(
          children: [
            // Header row with icon, name, and completion check
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: AppColors.blue500,
                      size: AppSizes.iconSize,
                    ),
                    const SizedBox(width: AppSizes.spacing3),
                    Text(name, style: AppTextStyles.h3),
                  ],
                ),
                if (completedToday)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.green500,
                    size: AppSizes.iconSize,
                  ),
              ],
            ),
            
            const SizedBox(height: AppSizes.spacing3),
            
            // Progress section
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('This week', style: AppTextStyles.bodySm),
                    Text('$totalCompleted/7 days', style: AppTextStyles.bodySmBlue),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing2),
                LinearProgressIndicator(
                  value: progressPercentage / 100,
                  backgroundColor: AppColors.blue50,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.blue500),
                  minHeight: AppSizes.progressBarHeight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.spacing3),
            
            // Days of the week indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                final isCompleted = weeklyProgress[index] == 1;
                
                return Container(
                  width: AppSizes.dayCircleSize,
                  height: AppSizes.dayCircleSize,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.blue500 : AppColors.blue50,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Center(
                    child: Text(
                      day.substring(0, 1),
                      style: TextStyle(
                        fontSize: AppSizes.fontSm,
                        fontWeight: FontWeight.w500,
                        color: isCompleted ? AppColors.white : AppColors.blue300,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}