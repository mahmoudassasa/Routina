enum LogoutStatus { initial, loading, success, error }

class LogoutState {
  final LogoutStatus status;
  final String? errorMessage;

  const LogoutState({
    this.status = LogoutStatus.initial,
    this.errorMessage,
  });

  LogoutState copyWith({
    LogoutStatus? status,
    String? errorMessage,
  }) {
    return LogoutState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
