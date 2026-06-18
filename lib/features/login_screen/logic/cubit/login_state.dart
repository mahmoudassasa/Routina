// Login States
enum LoginStatus { initial, loading, success, error }

class LoginState {
  final LoginStatus status;
  final String? errorMessage;
  final String? errorCode;
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.errorCode,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    String? errorCode,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
