  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:routina/core/widgets/logout_button/cubit/logout_state.dart';

  class LogoutCubit extends Cubit<LogoutState> {
    LogoutCubit() : super(const LogoutState());

    Future<void> logout() async {
      try {
        emit(state.copyWith(status: LogoutStatus.loading));
        await FirebaseAuth.instance.signOut();
        emit(state.copyWith(status: LogoutStatus.success));
      } catch (e) {
        emit(state.copyWith(
          status: LogoutStatus.error,
          errorMessage: e.toString(),
        ));
      }
    }
  }
