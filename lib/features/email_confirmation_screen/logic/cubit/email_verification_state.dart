part of 'email_verification_cubit.dart';

abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationLoading extends EmailVerificationState {}

class EmailVerificationEmailSent extends EmailVerificationState {}

class EmailVerificationVerified extends EmailVerificationState {}

class EmailVerificationNotVerified extends EmailVerificationState {}

class EmailVerificationTimerTick extends EmailVerificationState {
  final int seconds;
  EmailVerificationTimerTick(this.seconds);
}

class EmailVerificationTimerFinished extends EmailVerificationState {}

class EmailVerificationError extends EmailVerificationState {
  final String message;
  EmailVerificationError(this.message);
}
