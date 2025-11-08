import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      emit(state.copyWith(status: LoginStatus.success));
    } on FirebaseAuthException catch (e) {
      String message = '';

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
        default:
          message = 'Login failed, please try again.';
      }

      emit(state.copyWith(status: LoginStatus.error, errorMessage: message));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.error,
        errorMessage: 'Unexpected Error: $e',
      ));
    }
  }

  void reset() {
    emit(const LoginState());
  }
}
