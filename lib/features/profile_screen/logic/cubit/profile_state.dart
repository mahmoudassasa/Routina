import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool loading;
  final String? name;
  final String? email;
  final String? imageUrl;
  final String? errorMessage;
  final String? completionRate;
  final int? currentStreakCount;
  final int? totalHabitsCount;
  final int? bestStreakCount;

  const ProfileState({
    this.loading = false,
    this.name,
    this.email,
    this.imageUrl,
    this.errorMessage,
    this.completionRate,
    this.currentStreakCount,
    this.totalHabitsCount,
    this.bestStreakCount,
  });

  ProfileState copyWith({
    bool? loading,
    String? name,
    String? email,
    String? imageUrl,
    String? errorMessage,
    String? completionRate,
    int? currentStreakCount,
    int? totalHabitsCount,
    int? bestStreakCount,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      completionRate: completionRate ?? this.completionRate,
      currentStreakCount: currentStreakCount ?? this.currentStreakCount,
      totalHabitsCount: totalHabitsCount ?? this.totalHabitsCount,
      bestStreakCount: bestStreakCount ?? this.bestStreakCount,
    );
  }

  @override
  List<Object?> get props => [
        loading, name, email, imageUrl, errorMessage,
        completionRate, currentStreakCount, totalHabitsCount, bestStreakCount,
      ];
}