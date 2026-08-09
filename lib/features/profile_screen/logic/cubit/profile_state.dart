import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool loading;
  final String? name;
  final String? email;
  final String? imageUrl;
  final String? phone;
  final String? dob;
  final bool phoneVerified;
  final int totalHabitsCount;
  final int currentStreakCount;
  final String completionRate;
  final int bestStreakCount;
  final String? errorMessage;
  final bool profileCompleted;

  const ProfileState({
    this.loading = false,
    this.name,
    this.email,
    this.imageUrl,
    this.phone,
    this.dob,
    this.phoneVerified = false,
    this.totalHabitsCount = 0,
    this.currentStreakCount = 0,
    this.completionRate = '0%',
    this.bestStreakCount = 0,
    this.errorMessage,
    this.profileCompleted = false,
  });

  ProfileState copyWith({
    bool? loading,
    String? name,
    String? email,
    String? imageUrl,
    String? phone,
    String? dob,
    bool? phoneVerified,
    int? totalHabitsCount,
    int? currentStreakCount,
    String? completionRate,
    int? bestStreakCount,
    String? errorMessage,
    bool? profileCompleted,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      totalHabitsCount: totalHabitsCount ?? this.totalHabitsCount,
      currentStreakCount: currentStreakCount ?? this.currentStreakCount,
      completionRate: completionRate ?? this.completionRate,
      bestStreakCount: bestStreakCount ?? this.bestStreakCount,
      errorMessage: errorMessage ?? this.errorMessage,
      profileCompleted: profileCompleted ?? this.profileCompleted,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        name,
        email,
        imageUrl,
        phone,
        dob,
        phoneVerified,
        totalHabitsCount,
        currentStreakCount,
        completionRate,
        bestStreakCount,
        errorMessage,
        profileCompleted,
      ];
}