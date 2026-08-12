import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/services/google_sign_in_service.dart';
import 'package:routina/core/services/premium_service.dart';
import 'package:routina/features/login_screen/data/repos/login_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  final GoogleSignInService _googleSignInService;
  final supabase = Supabase.instance.client;

  LoginCubit(this._loginRepo, this._googleSignInService)
    : super(const LoginState());

  Future<void> _ensurePremiumRecord(String uid) async {
    try {
      await PremiumService().ensurePremiumRecord();
    } catch (_) {}
  }

  Future<void> signInWithGoogle() async {
    if (isClosed) return;
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      // This await can take an arbitrary amount of time — it waits on
      // the user picking an account in the external Google Sign-In
      // flow. If the person navigates away (e.g. signs out, closes the
      // login screen) while this is pending, this cubit gets closed
      // before the await resolves. Without the isClosed checks below,
      // resuming here and calling emit() throws "Bad state: Cannot
      // emit new states after calling close".
      final credential = await _googleSignInService.signInWithGoogle();

      if (isClosed) return;
      if (credential == null) {
        emit(state.copyWith(status: LoginStatus.initial));
        return;
      }

      final uid = credential.user!.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (isClosed) return;
      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'name': credential.user!.displayName ?? 'User',
          'email': credential.user!.email ?? '',
          'imageUrl':
              credential.user!.photoURL ??
              "https://gvqgliulacfmhscswyid.supabase.co/storage/v1/object/public/users/unknown.png",
          'createdAt': DateTime.now(),
        });
      }

      if (isClosed) return;
      await _ensurePremiumRecord(uid);

      if (isClosed) return;
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorCode: 'googleSignInFailed',
        ),
      );
    }
  }

  Future<void> login(String email, String password) async {
    if (isClosed) return;
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      firebase.UserCredential credential = await _loginRepo.signIn(
        email.trim(),
        password.trim(),
      );

      if (isClosed) return;
      firebase.User? user = credential.user;

      if (user != null && !user.emailVerified) {
        await _loginRepo.signOut();
        await firebase.FirebaseAuth.instance.signOut();
        if (isClosed) return;
        emit(state.copyWith(status: LoginStatus.error));
        return;
      }

      if (user != null) {
        await _ensurePremiumRecord(user.uid);
      }

      if (isClosed) return;
      emit(state.copyWith(status: LoginStatus.success));
    } on firebase.FirebaseAuthException catch (e) {
      if (isClosed) return;
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
      if (isClosed) return;
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
    if (isClosed) return;
    emit(const LoginState());
  }
}
