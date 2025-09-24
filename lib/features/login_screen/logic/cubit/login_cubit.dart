import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/features/login_screen/logic/cubit/login_state.dart';



// Login Cubit
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());
  
  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation
      if (email.isNotEmpty && password.isNotEmpty) {
        emit(state.copyWith(status: LoginStatus.success));
      } else {
        emit(state.copyWith(
          status: LoginStatus.error,
          errorMessage: 'Please fill all fields',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  void reset() {
    emit(const LoginState());
  }
}