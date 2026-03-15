import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool loading;
  final String? name;
  final String? email;
  final String? imageUrl;
  final String? errorMessage;
  final String? currentStreak;
  final String? totalHabits;
  final String? completionRate;
  final String? bestStreak;

  const ProfileState({
    this.loading = false,
    this.name,
    this.email,
    this.imageUrl,
    this.errorMessage,
    this.currentStreak,
    this.totalHabits,
    this.completionRate,
    this.bestStreak,
  });

  ProfileState copyWith({
    bool? loading,
    String? name,
    String? email,
    String? imageUrl,
    String? errorMessage,
    String? currentStreak,
    String? totalHabits,
    String? completionRate,
    String? bestStreak,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      currentStreak: currentStreak ?? this.currentStreak,
      totalHabits: totalHabits ?? this.totalHabits,
      completionRate: completionRate ?? this.completionRate,
      bestStreak: bestStreak ?? this.bestStreak,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        name,
        email,
        imageUrl,
        errorMessage,
        currentStreak,
        totalHabits,
        completionRate,
        bestStreak,
      ];
}