import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/features/home_screen/data/habit_service.dart';
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
    await _createHabit(
      title: title,
      iconKey: iconKey,
      colorValue: colorValue,
      days: days,
    );
  }

  Future<void> _createHabit({
    required String title,
    required String iconKey,
    required int colorValue,
    required List<bool> days,
  }) async {
    try {
      final tempId = DateTime.now().millisecondsSinceEpoch;
      final tempHabit = {
        'id': tempId,
        'title': title,
        'icon': iconKey,
        'color': colorValue,
        'frequency': days,
        'weekProgress': List.filled(7, false),
        'progress': 0.0,
        'streak': 0,
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
        if (habit['id'] == tempId) {
          return createdHabit;
        }
        return habit;
      }).toList();

      emit(state.copyWith(status: HomeStatus.loaded, habits: finalHabits));
    } catch (e) {
      final revertedHabits = state.habits
          .where(
            (habit) => habit['id'] != DateTime.now().millisecondsSinceEpoch,
          )
          .toList();
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: e.toString(),
          habits: revertedHabits,
        ),
      );
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
        (habit) => habit['id'] == habitId,
      );

      final List<bool> oldWeekProgress = List<bool>.from(
        habitToUpdate['weekProgress'] ?? List.filled(7, false),
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
        streak: habitToUpdate['streak'] ?? 0,
      );

      final updatedHabits = state.habits.map((habit) {
        if (habit['id'] == habitId) {
          return {
            ...habit,
            'title': title,
            'icon': iconKey,
            'color': colorValue,
            'frequency': normalizedDays,
            'weekProgress': updatedWeekProgress,
            'progress': newProgress,
          };
        }
        return habit;
      }).toList();

      emit(state.copyWith(habits: updatedHabits));
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> deleteHabit(dynamic habitId) async {
    try {
      final updatedHabits = state.habits
          .where((habit) => habit['id'] != habitId)
          .toList();

      emit(state.copyWith(habits: updatedHabits));

      await _habitService.deleteHabit(habitId as int);
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      );

      await loadHabits();
    }
  }

 Future<void> toggleDay(dynamic habitId, int dayIndex) async {
    // ممنوع تعديل أيام في المستقبل
    if (dayIndex > _todayIndex) return;

    final updatedHabits = state.habits.map((habit) {
      if (habit['id'] == habitId) {
        List<bool> weekProgress = List<bool>.from(habit['weekProgress']);
        List<bool> frequency = List<bool>.from(habit['frequency']);

        // 1. عكس حالة اليوم (Toggle)
        weekProgress[dayIndex] = !weekProgress[dayIndex];

        // 2. حساب نسبة الإنجاز (Progress)
        int scheduledDaysCount = frequency.where((day) => day).length;
        if (scheduledDaysCount == 0) scheduledDaysCount = 1;

        int completedDaysCount = 0;
        for (int i = 0; i < 7; i++) {
          if (frequency[i] && weekProgress[i]) completedDaysCount++;
        }

        double newProgress = completedDaysCount / scheduledDaysCount;
        if (newProgress > 1.0) newProgress = 1.0;

        // 3. (مهم جداً) تصحيح منطق الـ Streak
        // بنشوف الستريك القديم كام، ونزوده أو ننقصه بناءً على الاكشن
        int currentStreak = habit['streak'] ?? 0;

        if (weekProgress[dayIndex]) {
          // لو علمنا صح: بنزود الستريك
          currentStreak++;
        } else {
          // لو شلنا الصح: بننقص الستريك (بشرط ميكونش صفر)
          if (currentStreak > 0) currentStreak--;
        }
        
        // *ملحوظة للمستقبل:* // الطريقة دي بتعتمد على "عدد مرات الإنجاز" مش "التتابع الزمني الدقيق".
        // لو عايز تتابع دقيق (لو فوت يوم الستريك يتصفر)، لازم تخزن تاريخ "lastCompletedDate" في الداتابيز.

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

    try {
      final updatedHabit = updatedHabits.firstWhere(
        (habit) => habit['id'] == habitId,
      );

      await _habitService.updateHabitProgress(
        habitId: updatedHabit['id'] as int,
        frequency: List<bool>.from(updatedHabit['frequency'] as List),
        weekProgress: List<bool>.from(updatedHabit['weekProgress'] as List),
        progress: (updatedHabit['progress'] as num).toDouble(),
        streak: updatedHabit['streak'] as int, // ابعت الستريك الجديد للداتابيز
      );
    } catch (e) {
      // لو حصل ايرور، بنرجع الـ State القديمة (Rollback) عشان المستخدم ميحسش ان الاكشن تم
      // ممكن تعمل reloadHabits() هنا لو تحب
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      );
    }
  }




}
