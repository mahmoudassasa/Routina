import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      // Try signing in
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      User? user = credential.user;

      // ✅ Check if email is verified
      if (user != null && !user.emailVerified) {
        // Sign out because email is not verified
        await FirebaseAuth.instance.signOut();

        emit(
          state.copyWith(
            status: LoginStatus.error,
            errorMessage: 'Please verify your email before logging in 🔒',
          ),
        );
        return;
      }

      // ✅ If email is verified → success
      emit(state.copyWith(status: LoginStatus.success));
    } on FirebaseAuthException catch (e) {
      debugPrint("FIREBASE ERROR CODE: ${e.code}");
      debugPrint("FIREBASE ERROR MESSAGE: ${e.message}");
      String message;



      switch (e.code) {
        case 'invalid-email':
          message = 'Invalid email format 📧';
          break;

        case 'user-not-found':
          message = 'No user found with this email ❗';
          break;

        case 'wrong-password':
          message = 'Incorrect password 🔐';
          break;

        case 'invalid-credential':
        case 'invalid-login-credentials':
          message = 'Incorrect email or password ⚠️';
          break;

        case 'missing-password':
          message = 'Please enter your password 🔑';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Try again later ⏳';
          break;

        case 'user-disabled':
          message = 'This account has been disabled 🚫';
          break;

        default:
          message = 'Login failed, please try again.';
      }

      emit(state.copyWith(status: LoginStatus.error, errorMessage: message));
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: 'Unexpected Error: $e',
        ),
      );
    }
  }

  void reset() {
    emit(const LoginState());
  }
}
