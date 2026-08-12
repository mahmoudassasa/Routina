import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:routina/core/services/gemini_service.dart';
import 'package:routina/core/services/premium_service.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_state.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GeminiService _geminiService;
  final HomeCubit _homeCubit;
  final BillingCubit _billingCubit;
  final PremiumService _premiumService = PremiumService();
  late final StreamSubscription _homeSubscription;
  StreamSubscription? _billingSubscription;

  // Tracks which types are currently in-flight independently of the
  // shared state.geminiStatus field, so a 'goal' request is never
  // silently dropped just because 'smart' happens to be loading.
  final Set<String> _loadingTypes = {};

  // Caches the last completed result per type so tabs can display
  // their own analysis even after state.geminiType has moved on to
  // a different type due to a concurrent request finishing later.
  final Map<String, String> _cachedResults = {};

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

  /// Returns the cached result for [type], if any — useful for tabs
  /// that need to redisplay their own result even after a different
  /// type has since updated state.geminiType/geminiAnalysis.
  String? cachedResultFor(String type) => _cachedResults[type];

  bool isLoadingType(String type) => _loadingTypes.contains(type);

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
  try {
    final remaining = await _premiumService.getGeminiQuota();
    if (isClosed) return;
    emit(state.copyWith(remainingDailyRequests: remaining));
  } catch (_) {
    // Network hiccup — keep last known value instead of blocking the UI
  }
}

Future<void> _decrementDailyLimit() async {
  if (isClosed) return;
  try {
    final remaining = await _premiumService.incrementGeminiQuota();
    if (isClosed) return;
    emit(state.copyWith(remainingDailyRequests: remaining));
  } catch (_) {
    if (isClosed) return;
    emit(state.copyWith(status: AnalyticsStatus.error));
  }
}
  Future<void> fetchGeminiInsights(
    String type, {
    bool forceRefresh = false,
  }) async {
    // Per-type guard using the internal Set — 'goal' is no longer
    // dropped just because 'smart' is currently loading.
    if (_loadingTypes.contains(type)) return;
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
          _cachedResults[type] = cached;
          if (isClosed) return;
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

    _loadingTypes.add(type);
    if (isClosed) {
      _loadingTypes.remove(type);
      return;
    }
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

      _loadingTypes.remove(type);
      if (isClosed) return;

      if (!response.isFromCache) {
        await _decrementDailyLimit();
        try {
          await _premiumService.saveAnalysis(
            analysisText: response.text,
            period: type,
          );
        } catch (saveError) {
          throw Exception('Failed to save analysis: $saveError');
        }
      }

      _cachedResults[type] = response.text;

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
      _loadingTypes.remove(type);
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