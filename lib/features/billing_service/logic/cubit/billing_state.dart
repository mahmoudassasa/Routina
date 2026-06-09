part of 'billing_cubit.dart';

enum BillingStatus { initial, loading, active, expired, error }

class BillingState extends Equatable {
  final BillingStatus status;
  final bool isPremium;
  final DateTime? premiumUntil;
  final String? errorMessage;
  final bool isRestoring;

  const BillingState({
    this.status = BillingStatus.initial,
    this.isPremium = false,
    this.premiumUntil,
    this.errorMessage,
    this.isRestoring = false,
  });

  BillingState copyWith({
    BillingStatus? status,
    bool? isPremium,
    DateTime? premiumUntil,
    String? errorMessage,
    bool? isRestoring,
  }) {
    return BillingState(
      status: status ?? this.status,
      isPremium: isPremium ?? this.isPremium,
      premiumUntil: premiumUntil ?? this.premiumUntil,
      errorMessage: errorMessage ?? this.errorMessage,
      isRestoring: isRestoring ?? this.isRestoring,
    );
  }

  @override
  List<Object?> get props => [status, isPremium, premiumUntil, errorMessage, isRestoring];
}