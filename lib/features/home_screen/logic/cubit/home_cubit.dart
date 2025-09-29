import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/features/home_screen/logic/cubit/home_state.dart';


// Home Cubit
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());
  
  void loadHabits() {
    emit(state.copyWith(status: HomeStatus.loading));
    
    try {
      // Mock habits data with weekly progress
      final habits = [
        {
          'id': 1,
          'title': 'Morning Exercise',
          'icon': '🏃‍♂️',
          'progress': 0.7,
          'streak': 5,
          'completed': false,
          'weekProgress': [true, true, true, true, false, false, false], // Mon-Sun
        },
        {
          'id': 2,
          'title': 'Read 30 Minutes',
          'icon': '📚',
          'progress': 0.5,
          'streak': 3,
          'completed': false,
          'weekProgress': [true, false, true, true, false, false, false],
        },
        {
          'id': 3,
          'title': 'Drink 8 Glasses Water',
          'icon': '💧',
          'progress': 0.9,
          'streak': 12,
          'completed': true,
          'weekProgress': [true, true, true, true, true, true, false],
        },
        {
          'id': 4,
          'title': 'Meditation',
          'icon': '🧘‍♀️',
          'progress': 0.4,
          'streak': 2,
          'completed': false,
          'weekProgress': [false, true, false, true, false, false, false],
        },
        {
          'id': 5,
          'title': 'Journal Writing',
          'icon': '✍️',
          'progress': 0.8,
          'streak': 7,
          'completed': true,
          'weekProgress': [true, true, true, true, true, false, false],
        },
      ];
      
      emit(state.copyWith(
        status: HomeStatus.loaded,
        habits: habits,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  void toggleHabit(int habitId) {
    // Mock toggle habit completion
    final updatedHabits = state.habits.map((habit) {
      if (habit['id'] == habitId) {
        final isCompleted = habit['completed'] as bool;
        final currentProgress = habit['progress'] as double;
        final currentStreak = habit['streak'] as int;
        
        if (!isCompleted) {
          // Mark as completed today
          return {
            ...habit,
            'completed': true,
            'progress': 1.0,
            'streak': currentStreak + 1,
          };
        } else {
          // Unmark completion
          return {
            ...habit,
            'completed': false,
            'progress': currentProgress * 0.9, // Slight decrease
          };
        }
      }
      return habit;
    }).toList();
    
    emit(state.copyWith(habits: updatedHabits));
  }
}