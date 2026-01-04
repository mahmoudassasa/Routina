import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(const LogoutState());

  Future<void> logout() async {
    try {
      emit(state.copyWith(status: LogoutStatus.loading));

      // We add a warm delay so the user feels the "See you soon" message
      await Future.delayed(const Duration(milliseconds: 1500));

      // Signing out from Firebase is enough since Supabase is public storage
      await FirebaseAuth.instance.signOut();

      emit(state.copyWith(status: LogoutStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: LogoutStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void resetState() {
    emit(const LogoutState());
  }
}