import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:routina/core/services/gemini_service.dart';
import 'package:routina/core/services/premium_service.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_state.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GeminiService _geminiService;
  final HomeCubit _homeCubit;
  final BillingCubit _billingCubit;
  final PremiumService _premiumService = PremiumService();
  late final StreamSubscription _homeSubscription;
  StreamSubscription? _billingSubscription;

  AnalyticsCubit({
    required HomeCubit homeCubit,
    required BillingCubit billingCubit,
    GeminiService? geminiService,
  })  : _geminiService = geminiService ?? GeminiService(),
        _homeCubit = homeCubit,
        _billingCubit = billingCubit,
        super(AnalyticsState(isPremiumUser: billingCubit.state.isPremium)) {
    _homeSubscription = _homeCubit.stream.listen((homeState) {
      if (homeState.status == HomeStatus.loaded) {
        _computeLocalAnalytics(homeState.habits);
      }
    });

    _billingSubscription = _billingCubit.stream.listen((billingState) {
      if (!isClosed) {
        if (state.isPremiumUser != billingState.isPremium) {
          emit(state.copyWith(isPremiumUser: billingState.isPremium));
          _updateDailyLimit(billingState.isPremium);
        }
      }
    });

    final currentHomeState = _homeCubit.state;
    if (currentHomeState.status == HomeStatus.loaded) {
      _computeLocalAnalytics(currentHomeState.habits);
    }
    _updateDailyLimit(_billingCubit.state.isPremium);
  }

  @override
  Future<void> close() {
    _homeSubscription.cancel();
    _billingSubscription?.cancel();
    return super.close();
  }

  void _computeLocalAnalytics(List<Map<String, dynamic>> habits) {
    if (isClosed) return;

    if (habits.isEmpty) {
      emit(
        state.copyWith(
          status: AnalyticsStatus.loaded,
          totalHabits: 0,
          averageProgress: 0.0,
          bestStreak: 0,
          bestStreakHabitName: '',
          habitProgressMap: {},
          weeklyChartData: _generateEmptyWeeklyChart(),
        ),
      );
      return;
    }

    final total = habits.length;
    final progressMap = <String, double>{};
    double maxProgress = -1.0;
    int bestStreak = 0;

    for (final h in habits) {
      final title = h['title'] ?? 'Unknown';
      final progress = (h['progress'] ?? 0.0).toDouble();
      final streak = (h['streak'] ?? 0) as int;

      progressMap[title] = progress;
      if (streak > bestStreak) bestStreak = streak;
      if (progress > maxProgress) maxProgress = progress;
    }

    final avg = total > 0 ? progressMap.values.reduce((a, b) => a + b) / total : 0.0;

    List<String> topPerformers = [];
    for (final h in habits) {
      final progress = (h['progress'] ?? 0.0).toDouble();
      if (progress == maxProgress) {
        topPerformers.add(h['title'] ?? '');
      }
    }

    String bestHabitName = '';
    if (topPerformers.length == total && total > 1) {
      bestHabitName = 'All Equal';
    } else if (topPerformers.length > 1) {
      bestHabitName = 'Multiple';
    } else if (topPerformers.isNotEmpty) {
      bestHabitName = topPerformers.first;
    }

    final weeklyData = _generateWeeklyChartData(habits);

    if (isClosed) return;
    emit(
      state.copyWith(
        status: AnalyticsStatus.loaded,
        totalHabits: total,
        averageProgress: avg,
        bestStreak: bestStreak,
        bestStreakHabitName: bestHabitName,
        habitProgressMap: progressMap,
        weeklyChartData: weeklyData,
      ),
    );
  }

  List<FlSpot> _generateWeeklyChartData(List<Map<String, dynamic>> habits) {
    final spots = <FlSpot>[];
    for (int i = 0; i < 7; i++) {
      double total = 0;
      int count = 0;
      for (final h in habits) {
        final weekProgress = h['weekProgress'] as List?;
        if (weekProgress != null && weekProgress.length > i) {
          total += (weekProgress[i] == true ? 1.0 : 0.0);
          count++;
        }
      }
      final avg = count > 0 ? total / count : 0.0;
      spots.add(FlSpot(i.toDouble(), avg * 100));
    }
    return spots;
  }

  List<FlSpot> _generateEmptyWeeklyChart() {
    return List.generate(7, (i) => FlSpot(i.toDouble(), 0.0));
  }

  Future<void> _updateDailyLimit(bool isPremium) async {
    if (isClosed) return;
    final prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    final key = 'gemini_daily_limit_${userId}_overall';
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final storedDate = prefs.getString('${key}_date');

    int remaining;
    if (storedDate != today) {
      remaining = isPremium ? 30 : 3;
      await prefs.setString('${key}_date', today);
      await prefs.setInt(key, 0);
    } else {
      final used = prefs.getInt(key) ?? 0;
      final limit = isPremium ? 30 : 3;
      remaining = max(0, limit - used);
    }

    if (isClosed) return;
    emit(state.copyWith(remainingDailyRequests: remaining));
  }

  Future<void> _decrementDailyLimit() async {
    if (isClosed) return;
    final prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    final key = 'gemini_daily_limit_${userId}_overall';
    final used = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, used + 1);
    final isPremium = state.isPremiumUser;
    final limit = isPremium ? 30 : 3;
    final remaining = max(0, limit - (used + 1));
    if (isClosed) return;
    emit(state.copyWith(remainingDailyRequests: remaining));
  }

  Future<void> fetchGeminiInsights(
    String type, {
    bool forceRefresh = false,
  }) async {
    if (state.geminiStatus == GeminiStatus.loading) return;
    if (isClosed) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      if (isClosed) return;
      emit(
        state.copyWith(
          geminiStatus: GeminiStatus.error,
          geminiError: 'User not logged in',
          geminiType: type,
        ),
      );
      return;
    }

    if (type != 'overall' && !state.isPremiumUser) {
      if (isClosed) return;
      emit(
        state.copyWith(
          geminiStatus: GeminiStatus.error,
          geminiError: 'premium_required',
          geminiType: type,
        ),
      );
      return;
    }

    final homeState = _homeCubit.state;
    if (homeState.status != HomeStatus.loaded || homeState.habits.isEmpty) {
      if (isClosed) return;
      emit(
        state.copyWith(
          geminiStatus: GeminiStatus.error,
          geminiError: 'no_habits',
          geminiType: type,
        ),
      );
      return;
    }

    if (!forceRefresh) {
      try {
        final cached = await _premiumService.getAnalysis(period: type);
        if (cached != null) {
          emit(
            state.copyWith(
              geminiStatus: GeminiStatus.loaded,
              geminiAnalysis: cached,
              geminiError: null,
              geminiType: type,
            ),
          );
          return;
        }
      } catch (_) {
        // Ignore cache errors and proceed to fetch fresh
      }
    }

    await _updateDailyLimit(state.isPremiumUser);
    if (state.remainingDailyRequests <= 0) {
      if (isClosed) return;
      emit(
        state.copyWith(
          geminiStatus: GeminiStatus.error,
          geminiError: 'quota_exceeded',
          geminiType: type,
        ),
      );
      return;
    }

    if (isClosed) return;
    emit(
      state.copyWith(
        geminiStatus: GeminiStatus.loading,
        geminiError: null,
        geminiType: type,
      ),
    );

    try {
      final response = await _geminiService.fetchCachedAnalysis(
        userId: userId,
        type: type,
        habits: homeState.habits,
        isPremium: state.isPremiumUser,
        forceRefresh: forceRefresh,
      );

      if (isClosed) return;

      if (!response.isFromCache) {
        await _decrementDailyLimit();
        try {
          await _premiumService.saveAnalysis(
            analysisText: response.text,
            period: type,
          );
        } catch (saveError) {
          print('Failed to save analysis to Supabase: $saveError');
        }
      }

      if (isClosed) return;
      emit(
        state.copyWith(
          geminiStatus: GeminiStatus.loaded,
          geminiAnalysis: response.text,
          geminiError: null,
          geminiType: type,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      final errorMsg = e.toString().contains('rate_limited')
          ? 'rate_limited'
          : e.toString().contains('quota_exceeded')
              ? 'quota_exceeded'
              : e.toString();
      emit(
        state.copyWith(
          geminiStatus: GeminiStatus.error,
          geminiError: errorMsg,
          geminiType: type,
        ),
      );
    }
  }

  void resetGemini() {
    if (isClosed) return;
    emit(
      state.copyWith(
        geminiStatus: GeminiStatus.idle,
        geminiAnalysis: null,
        geminiError: null,
      ),
    );
  }

  void refreshLocal() {
    if (isClosed) return;
    final homeState = _homeCubit.state;
    if (homeState.status == HomeStatus.loaded) {
      _computeLocalAnalytics(homeState.habits);
    }
  }
}