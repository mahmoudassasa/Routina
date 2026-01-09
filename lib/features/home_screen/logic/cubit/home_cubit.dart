import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());
  // Helper to get real today index (0 = Mon, 6 = Sun)
  int get _todayIndex {
    // DateTime.weekday returns 1 for Mon, 7 for Sun. We need 0-6.
    return DateTime.now().weekday - 1;
  }

  void loadHabits() {
    emit(state.copyWith(status: HomeStatus.loading));

    // Mock Data to visualize the professional UI
    final List<Map<String, dynamic>> mockHabits = [
      {
        'id': 1,
        'title': 'Morning Yoga',
        'icon': 'sport',
        'color': 0xFFFF6B6B,
        'progress': 0.5,
        'streak': 5,
        'weekProgress': [true, false, true, false, false, false, false],
        'frequency': [true, true, true, true, true, false, false],
      },
      {
        'id': 2,
        'title': 'Read Books',
        'icon': 'read',
        'color': 0xFF4ECDC4,
        'progress': 0.2,
        'streak': 3,
        'weekProgress': [false, true, false, false, false, false, false],
        'frequency': [true, true, true, true, true, true, true],
      },
    ];

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(state.copyWith(status: HomeStatus.loaded, habits: mockHabits));
    });
  }

  void addHabit({
    required String title,
    required String iconKey,
    required int colorValue,
    required List<bool> days,
  }) {
    final newHabit = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': title,
      'icon': iconKey,
      'color': colorValue,
      'progress': 0.0,
      'streak': 0,
      'weekProgress': List.generate(7, (index) => false),
      'frequency': days,
    };

    final updatedHabits = List<Map<String, dynamic>>.from(state.habits)..add(newHabit);
    emit(state.copyWith(status: HomeStatus.loaded, habits: updatedHabits));
  }

// Toggle Day Logic (Smart Calculation)
  void toggleDay(dynamic habitId, int dayIndex) {
    final updatedHabits = state.habits.map((habit) {
      if (habit['id'] == habitId) {
        List<bool> weekProgress = List<bool>.from(habit['weekProgress']);
        List<bool> frequency = List<bool>.from(habit['frequency']);

        // Toggle the status
        weekProgress[dayIndex] = !weekProgress[dayIndex];

        // Recalculate Progress
        int scheduledDaysCount = frequency.where((day) => day).length;
        
        // Safety check: If scheduled count is 0 (shouldn't happen with validation), avoid crash
        if (scheduledDaysCount == 0) scheduledDaysCount = 1; 

        int completedDaysCount = 0;
        for (int i = 0; i < 7; i++) {
          // Only count if it was scheduled AND is done
          if (frequency[i] && weekProgress[i]) completedDaysCount++;
        }

        double newProgress = completedDaysCount / scheduledDaysCount;
        if (newProgress > 1.0) newProgress = 1.0; // Cap at 100%

        // Determine if Streak should increase (Simple logic: if today is done)
        int currentStreak = habit['streak'] ?? 0;
        // If we just checked TODAY, increase streak. If unchecked TODAY, decrease.
        if (dayIndex == _todayIndex) {
          if (weekProgress[dayIndex]) {
             currentStreak++; 
          } else if (currentStreak > 0) {
             currentStreak--;
          }
        }

        return {
          ...habit,
          'weekProgress': weekProgress,
          'progress': newProgress,
          'streak': currentStreak,
        };
      }
      return habit;
    }).toList();

    emit(state.copyWith(habits: updatedHabits));
  }
}
