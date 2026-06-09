import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/services/google_sign_in_service.dart';
import 'package:routina/features/login_screen/data/repos/login_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  final GoogleSignInService _googleSignInService;

  LoginCubit(this._loginRepo, this._googleSignInService)
    : super(const LoginState());
  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final credential = await _googleSignInService.signInWithGoogle();
      if (credential == null) {
        emit(state.copyWith(status: LoginStatus.initial));
        return;
      }
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorCode: 'googleSignInFailed',
        ),
      );
    }
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      UserCredential credential = await _loginRepo.signIn(
        email.trim(),
        password.trim(),
      );
      User? user = credential.user;

      if (user != null && !user.emailVerified) {
        await _loginRepo.signOut();
        await FirebaseAuth.instance.signOut();
        emit(
          state.copyWith(
            status: LoginStatus.error,
            errorCode: 'pleaseVerifyEmail', // ← code بدل message
          ),
        );
        return;
      }

      emit(state.copyWith(status: LoginStatus.success));
    } on FirebaseAuthException catch (e) {
      final code = switch (e.code) {
        'invalid-email' => 'invalidEmail',
        'user-not-found' => 'userNotFound',
        'wrong-password' => 'wrongPassword',
        'invalid-credential' => 'invalidCredential',
        'invalid-login-credentials' => 'invalidCredential',
        'missing-password' => 'missingPassword',
        'too-many-requests' => 'tooManyRequests',
        'user-disabled' => 'userDisabled',
        _ => 'loginFailed',
      };
      emit(state.copyWith(status: LoginStatus.error, errorCode: code));
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorCode: 'unexpectedError',
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void reset() {
    emit(const LoginState());
  }
}
