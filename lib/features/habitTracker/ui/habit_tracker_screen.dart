import 'package:flutter/material.dart';
import 'widgets/habit_card_widget.dart';
import '../../../core/helpers/app_constants.dart';

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final habits = [
      {
        'name': 'Drink Water',
        'icon': Icons.water_drop,
        'weeklyProgress': [1, 1, 0, 1, 1, 1, 0],
        'completedToday': false,
      },
      {
        'name': 'Workout',
        'icon': Icons.fitness_center,
        'weeklyProgress': [1, 0, 1, 1, 0, 1, 0],
        'completedToday': true,
      },
      {
        'name': 'Reading',
        'icon': Icons.menu_book,
        'weeklyProgress': [1, 1, 1, 0, 1, 1, 1],
        'completedToday': true,
      },
      {
        'name': 'Sleep 8hrs',
        'icon': Icons.bedtime,
        'weeklyProgress': [0, 1, 1, 1, 0, 1, 1],
        'completedToday': false,
      },
      {
        'name': 'Healthy Eating',
        'icon': Icons.apple,
        'weeklyProgress': [1, 1, 0, 1, 1, 0, 1],
        'completedToday': true,
      },
      {
        'name': 'Meditation',
        'icon': Icons.self_improvement,
        'weeklyProgress': [1, 0, 1, 0, 1, 1, 0],
        'completedToday': false,
      },
    ];
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blue25, AppColors.indigo25],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'My Habits',
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: AppSizes.spacing2),
              const Text(
                'Track your daily habits and build consistency',
                style: AppTextStyles.bodySm,
              ),
              
              const SizedBox(height: AppSizes.spacing6),
              
              // Add Habit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add habit feature coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Habit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue500,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing6),
                  
              // Habits List
              ...habits.map((habit) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spacing4),
                child: HabitCardWidget(
                  icon: habit['icon'] as IconData,
                  name: habit['name'] as String,
                  weeklyProgress: List<int>.from(habit['weeklyProgress'] as List),
                  completedToday: habit['completedToday'] as bool,
                ),
              )),
              
              const SizedBox(height: AppSizes.spacing8),
            ],
          ),
        ),
      ),
    );
  }
}