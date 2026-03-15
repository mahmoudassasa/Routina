import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/habit_keys.dart';
import 'package:routina/features/home_screen/data/habit_service.dart';
// Make sure to import your HabitKeys file here
// import 'path_to_your_habit_keys_file.dart'; 
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({HabitService? habitService})
      : _habitService = habitService ?? HabitService(),
        super(const HomeState());

  final HabitService _habitService;

  int get _todayIndex {
    return DateTime.now().weekday - 1;
  }

  Future<void> loadHabits() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final habits = await _habitService.fetchHabitsForCurrentUser();
      emit(state.copyWith(status: HomeStatus.loaded, habits: habits));
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> addHabit({
    required String title,
    required String iconKey,
    required int colorValue,
    required List<bool> days,
  }) async {
    try {
      final tempId = DateTime.now().millisecondsSinceEpoch;
      final tempHabit = {
        HabitKeys.id: tempId,
        HabitKeys.title: title,
        HabitKeys.icon: iconKey,
        HabitKeys.color: colorValue,
        HabitKeys.frequency: days,
        HabitKeys.weekProgress: List.filled(7, false),
        HabitKeys.progress: 0.0,
        HabitKeys.streak: 0,
      };

      final updatedHabits = List<Map<String, dynamic>>.from(state.habits)
        ..add(tempHabit);
      emit(state.copyWith(status: HomeStatus.loaded, habits: updatedHabits));

      final createdHabit = await _habitService.createHabitForCurrentUser(
        title: title,
        iconKey: iconKey,
        colorValue: colorValue,
        days: days,
      );

      final finalHabits = updatedHabits.map((habit) {
        if (habit[HabitKeys.id] == tempId) {
          return createdHabit;
        }
        return habit;
      }).toList();

      emit(state.copyWith(status: HomeStatus.loaded, habits: finalHabits));
    } catch (e) {
      await loadHabits();
      emit(state.copyWith(status: HomeStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> updateHabit({
    required dynamic habitId,
    required String title,
    required String iconKey,
    required int colorValue,
    required List<bool> days,
  }) async {
    try {
      final habitToUpdate = state.habits.firstWhere(
        (habit) => habit[HabitKeys.id] == habitId,
      );

      final List<bool> oldWeekProgress = List<bool>.from(
        habitToUpdate[HabitKeys.weekProgress] ?? List.filled(7, false),
      );
      final List<bool> normalizedDays = List<bool>.from(days);

      final List<bool> updatedWeekProgress = List<bool>.from(oldWeekProgress);
      for (int i = 0; i < 7; i++) {
        if (!normalizedDays[i]) {
          updatedWeekProgress[i] = false;
        }
      }

      int scheduledDaysCount = normalizedDays.where((day) => day).length;
      if (scheduledDaysCount == 0) scheduledDaysCount = 1;

      int completedDaysCount = 0;
      for (int i = 0; i < 7; i++) {
        if (normalizedDays[i] && updatedWeekProgress[i]) completedDaysCount++;
      }

      double newProgress = completedDaysCount / scheduledDaysCount;
      if (newProgress > 1.0) newProgress = 1.0;

      await _habitService.updateHabit(
        habitId: habitId as int,
        title: title,
        iconKey: iconKey,
        colorValue: colorValue,
        days: normalizedDays,
      );

      await _habitService.updateHabitProgress(
        habitId: habitId,
        frequency: normalizedDays,
        weekProgress: updatedWeekProgress,
        progress: newProgress,
        streak: habitToUpdate[HabitKeys.streak] ?? 0,
      );

      final updatedHabitsList = state.habits.map((habit) {
        if (habit[HabitKeys.id] == habitId) {
          return {
            ...habit,
            HabitKeys.title: title,
            HabitKeys.icon: iconKey,
            HabitKeys.color: colorValue,
            HabitKeys.frequency: normalizedDays,
            HabitKeys.weekProgress: updatedWeekProgress,
            HabitKeys.progress: newProgress,
          };
        }
        return habit;
      }).toList();

      emit(state.copyWith(habits: updatedHabitsList));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> toggleDay(dynamic habitId, int dayIndex) async {
    if (dayIndex != _todayIndex) return;

    final updatedHabits = state.habits.map((habit) {
      if (habit[HabitKeys.id] == habitId) {
        List<bool> weekProgress = List<bool>.from(habit[HabitKeys.weekProgress]);
        List<bool> frequency = List<bool>.from(habit[HabitKeys.frequency]);

        weekProgress[dayIndex] = !weekProgress[dayIndex];

        int scheduledDaysCount = frequency.where((day) => day).length;
        if (scheduledDaysCount == 0) scheduledDaysCount = 1;

        int completedDaysCount = 0;
        for (int i = 0; i < 7; i++) {
          if (frequency[i] && weekProgress[i]) completedDaysCount++;
        }

        double newProgress = (completedDaysCount / scheduledDaysCount).toDouble();
        if (newProgress > 1.0) newProgress = 1.0;

        int currentStreak = habit[HabitKeys.streak] ?? 0;
        if (weekProgress[dayIndex]) {
          currentStreak++;
        } else {
          if (currentStreak > 0) currentStreak--;
        }

        return {
          ...habit,
          HabitKeys.weekProgress: weekProgress,
          HabitKeys.progress: newProgress,
          HabitKeys.streak: currentStreak,
        };
      }
      return habit;
    }).toList();

    emit(state.copyWith(habits: updatedHabits));

    try {
      final updatedHabit = updatedHabits.firstWhere(
        (habit) => habit[HabitKeys.id] == habitId,
      );

      await _habitService.updateHabitProgress(
        habitId: updatedHabit[HabitKeys.id] as int,
        frequency: List<bool>.from(updatedHabit[HabitKeys.frequency]),
        weekProgress: List<bool>.from(updatedHabit[HabitKeys.weekProgress]),
        progress: (updatedHabit[HabitKeys.progress] as num).toDouble(),
        streak: updatedHabit[HabitKeys.streak] as int,
      );
    } catch (e) {
      await loadHabits();
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: "Sync failed: ${e.toString()}",
      ));
    }
  }

  Future<void> deleteHabit(dynamic habitId) async {
    try {
      final updatedHabits = state.habits
          .where((habit) => habit[HabitKeys.id] != habitId)
          .toList();

      emit(state.copyWith(habits: updatedHabits));
      await _habitService.deleteHabit(habitId as int);
    } catch (e) {
      await loadHabits();
      emit(state.copyWith(status: HomeStatus.error, errorMessage: e.toString()));
    }
  }
}