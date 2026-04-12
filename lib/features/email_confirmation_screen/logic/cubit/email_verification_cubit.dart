import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  EmailVerificationCubit() : super(EmailVerificationInitial()) {
    startResendTimer();
  }

  Timer? _timer;
  int remainingSeconds = 60;

  void startResendTimer() {
    remainingSeconds = 60; 
    emit(EmailVerificationTimerTick(remainingSeconds));

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds--;
      if (remainingSeconds <= 0) {
        timer.cancel();
        emit(EmailVerificationTimerFinished());
      } else {
        emit(EmailVerificationTimerTick(remainingSeconds));
      }
    });
  }

  Future<void> resendEmail() async {
    try {
      emit(EmailVerificationLoading());
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      emit(EmailVerificationEmailSent());
      startResendTimer();
    } catch (_) {
      emit(EmailVerificationError("Error sending verification email"));
    }
  }

  Future<void> checkVerification() async {
  try {
    emit(EmailVerificationLoading());

    // Force refresh user data
    await FirebaseAuth.instance.currentUser?.reload();
    await Future.delayed(const Duration(seconds: 1));

    final user = FirebaseAuth.instance.currentUser;


    if (user != null && user.emailVerified) {
      emit(EmailVerificationVerified());
    } else {
      emit(EmailVerificationNotVerified());
    }
  } catch (e) {
    emit(EmailVerificationError("Error checking verification status: $e"));
  }
}


  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
