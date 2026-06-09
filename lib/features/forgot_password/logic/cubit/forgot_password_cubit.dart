import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  Future<void> sendResetPasswordEmail(String email) async {
    if (email.isEmpty) {
      emit(state.copyWith(status: ForgotPasswordStatus.error, errorMessage: "Please enter your email"));
      return;
    }

    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      
      // Heartfelt delay to ensure the user sees our premium loading animation
      await Future.delayed(const Duration(milliseconds: 1200));
      
      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred. Please try again.";
      if (e.code == 'user-not-found') message = "No user found with this email.";
      if (e.code == 'invalid-email') message = "The email address is not valid.";
      
      emit(state.copyWith(status: ForgotPasswordStatus.error, errorMessage: message));
    } catch (e) {
      emit(state.copyWith(status: ForgotPasswordStatus.error, errorMessage: e.toString()));
    }
  }
}