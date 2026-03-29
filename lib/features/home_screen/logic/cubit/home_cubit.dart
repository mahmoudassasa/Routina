import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/habit_keys.dart';
import 'package:routina/features/home_screen/data/habit_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({HabitService? habitService})
      : _habitService = habitService ?? HabitService(),
        super(const HomeState());

  final HabitService _habitService;

  int get _todayIndex => DateTime.now().weekday - 1;

  // ── Load ───────────────────────────────────────────────────────────────

  Future<void> loadHabits() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final habits = await _habitService.fetchHabitsForCurrentUser();
      final checkedHabits = await _checkAndResetIfNeeded(habits);
      emit(state.copyWith(status: HomeStatus.loaded, habits: checkedHabits));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.error, errorMessage: e.toString()));
    }
  }

  // ── Reset logic ────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> _checkAndResetIfNeeded(
    List<Map<String, dynamic>> habits,
  ) async {
    final now = DateTime.now();
    final todayOnly = DateTime(now.year, now.month, now.day);
    final result = <Map<String, dynamic>>[];

    for (final habit in habits) {
      // اقرأ الـ lastSeenDate — لو null معناه أول مرة يفتح، اعتبره النهارده
      final lastSeenRaw = habit[HabitKeys.lastSeenDate];
      final lastSeen = lastSeenRaw != null
          ? DateTime.parse(lastSeenRaw.toString())
          : todayOnly;
      final lastSeenOnly =
          DateTime(lastSeen.year, lastSeen.month, lastSeen.day);
      final daysDiff = todayOnly.difference(lastSeenOnly).inDays;

      // نفس اليوم → مفيش حاجة خالص
      if (daysDiff == 0) {
        result.add(habit);
        continue;
      }

      final frequency = List<bool>.from(
          habit[HabitKeys.frequency] ?? List.filled(7, true));
      final weekProgress = List<bool>.from(
          habit[HabitKeys.weekProgress] ?? List.filled(7, false));

      // هل في يوم scheduled فاته المستخدم من غير ما يكمله؟
      bool missedScheduledDay = false;
      for (int d = 1; d <= daysDiff; d++) {
        final missedDate = todayOnly.subtract(Duration(days: d));
        final missedIndex = missedDate.weekday - 1; // 0=Mon … 6=Sun
        if (frequency[missedIndex] && !weekProgress[missedIndex]) {
          missedScheduledDay = true;
          break;
        }
      }

      if (missedScheduledDay) {
        // ريست كامل
        await _habitService.updateHabitProgress(
          habitId: habit[HabitKeys.id] as int,
          frequency: frequency,
          weekProgress: List.filled(7, false),
          progress: 0.0,
          streak: 0,
          lastSeenDate: todayOnly,
        );
        result.add({
          ...habit,
          HabitKeys.streak: 0,
          HabitKeys.weekProgress: List.filled(7, false),
          HabitKeys.progress: 0.0,
          HabitKeys.lastSeenDate: todayOnly.toIso8601String(),
        });
      } else {
        // الأيام اللي فاتت كلها rest days → بس حدّث lastSeenDate
        await _habitService.updateHabitProgress(
          habitId: habit[HabitKeys.id] as int,
          frequency: frequency,
          weekProgress: weekProgress,
          progress: (habit[HabitKeys.progress] as num).toDouble(),
          streak: habit[HabitKeys.streak] as int,
          lastSeenDate: todayOnly,
        );
        result.add({
          ...habit,
          HabitKeys.lastSeenDate: todayOnly.toIso8601String(),
        });
      }
    }

    return result;
  }

  // ── Add ────────────────────────────────────────────────────────────────

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
        HabitKeys.lastSeenDate: DateTime.now().toIso8601String(),
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
        if (habit[HabitKeys.id] == tempId) return createdHabit;
        return habit;
      }).toList();

      emit(state.copyWith(status: HomeStatus.loaded, habits: finalHabits));
    } catch (e) {
      await loadHabits();
      emit(state.copyWith(
          status: HomeStatus.error, errorMessage: e.toString()));
    }
  }

  // ── Update ─────────────────────────────────────────────────────────────

  Future<void> updateHabit({
    required dynamic habitId,
    required String title,
    required String iconKey,
    required int colorValue,
    required List<bool> days,
  }) async {
    try {
      final habitToUpdate = state.habits
          .firstWhere((habit) => habit[HabitKeys.id] == habitId);

      final oldWeekProgress = List<bool>.from(
          habitToUpdate[HabitKeys.weekProgress] ?? List.filled(7, false));
      final normalizedDays = List<bool>.from(days);

      // لو يوم اتشال من الـ frequency، امسح تقدمه
      final updatedWeekProgress = List<bool>.from(oldWeekProgress);
      for (int i = 0; i < 7; i++) {
        if (!normalizedDays[i]) updatedWeekProgress[i] = false;
      }

      int scheduledCount = normalizedDays.where((d) => d).length;
      if (scheduledCount == 0) scheduledCount = 1;

      int completedCount = 0;
      for (int i = 0; i < 7; i++) {
        if (normalizedDays[i] && updatedWeekProgress[i]) completedCount++;
      }

      double newProgress = (completedCount / scheduledCount).clamp(0.0, 1.0);

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

      final updatedList = state.habits.map((habit) {
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

      emit(state.copyWith(habits: updatedList));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.error, errorMessage: e.toString()));
    }
  }

  // ── Toggle day ─────────────────────────────────────────────────────────

  Future<void> toggleDay(dynamic habitId, int dayIndex) async {
    if (dayIndex != _todayIndex) return;

    final updatedHabits = state.habits.map((habit) {
      if (habit[HabitKeys.id] == habitId) {
        final weekProgress =
            List<bool>.from(habit[HabitKeys.weekProgress]);
        final frequency = List<bool>.from(habit[HabitKeys.frequency]);

        weekProgress[dayIndex] = !weekProgress[dayIndex];

        int scheduledCount = frequency.where((d) => d).length;
        if (scheduledCount == 0) scheduledCount = 1;

        int completedCount = 0;
        for (int i = 0; i < 7; i++) {
          if (frequency[i] && weekProgress[i]) completedCount++;
        }

        final newProgress =
            (completedCount / scheduledCount).clamp(0.0, 1.0).toDouble();

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
      final updated =
          updatedHabits.firstWhere((h) => h[HabitKeys.id] == habitId);

      await _habitService.updateHabitProgress(
        habitId: updated[HabitKeys.id] as int,
        frequency: List<bool>.from(updated[HabitKeys.frequency]),
        weekProgress: List<bool>.from(updated[HabitKeys.weekProgress]),
        progress: (updated[HabitKeys.progress] as num).toDouble(),
        streak: updated[HabitKeys.streak] as int,
        lastSeenDate: DateTime.now(),
      );
    } catch (e) {
      await loadHabits();
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Sync failed: ${e.toString()}',
      ));
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────

  Future<void> deleteHabit(dynamic habitId) async {
    try {
      final updatedHabits = state.habits
          .where((habit) => habit[HabitKeys.id] != habitId)
          .toList();

      emit(state.copyWith(habits: updatedHabits));
      await _habitService.deleteHabit(habitId as int);
    } catch (e) {
      await loadHabits();
      emit(state.copyWith(
          status: HomeStatus.error, errorMessage: e.toString()));
    }
  }
}