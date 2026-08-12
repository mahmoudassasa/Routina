import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

enum AnalyticsStatus { initial, loading, loaded, error }
enum GeminiStatus { idle, loading, loaded, error }

class AnalyticsState extends Equatable {
  final AnalyticsStatus status;
  final String? errorMessage;

  final int totalHabits;
  final double averageProgress;
  final int bestStreak;
  final String bestStreakHabitName;
  final Map<String, double> habitProgressMap;
  final List<FlSpot> weeklyChartData;

  final GeminiStatus geminiStatus;
  final String? geminiAnalysis;
  final String? geminiError;
  final String? geminiType;

  final int remainingDailyRequests;
  final bool isPremiumUser;

  const AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.errorMessage,
    this.totalHabits = 0,
    this.averageProgress = 0.0,
    this.bestStreak = 0,
    this.bestStreakHabitName = '',
    this.habitProgressMap = const {},
    this.weeklyChartData = const [],
    this.geminiStatus = GeminiStatus.idle,
    this.geminiAnalysis,
    this.geminiError,
    this.geminiType,
    this.remainingDailyRequests = 3,
    this.isPremiumUser = false,
  });

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    String? errorMessage,
    int? totalHabits,
    double? averageProgress,
    int? bestStreak,
    String? bestStreakHabitName,
    Map<String, double>? habitProgressMap,
    List<FlSpot>? weeklyChartData,
    GeminiStatus? geminiStatus,
    String? geminiAnalysis,
    String? geminiError,
    String? geminiType,
    int? remainingDailyRequests,
    bool? isPremiumUser,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      totalHabits: totalHabits ?? this.totalHabits,
      averageProgress: averageProgress ?? this.averageProgress,
      bestStreak: bestStreak ?? this.bestStreak,
      bestStreakHabitName: bestStreakHabitName ?? this.bestStreakHabitName,
      habitProgressMap: habitProgressMap ?? this.habitProgressMap,
      weeklyChartData: weeklyChartData ?? this.weeklyChartData,
      geminiStatus: geminiStatus ?? this.geminiStatus,
      geminiAnalysis: geminiAnalysis ?? this.geminiAnalysis,
      geminiError: geminiError ?? this.geminiError,
      geminiType: geminiType ?? this.geminiType,
      remainingDailyRequests: remainingDailyRequests ?? this.remainingDailyRequests,
      isPremiumUser: isPremiumUser ?? this.isPremiumUser,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        totalHabits,
        averageProgress,
        bestStreak,
        bestStreakHabitName,
        habitProgressMap,
        weeklyChartData,
        geminiStatus,
        geminiAnalysis,
        geminiError,
        geminiType,
        remainingDailyRequests,
        isPremiumUser,
      ];
}