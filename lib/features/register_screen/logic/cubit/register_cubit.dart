import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/features/register_screen/logic/cubit/register_state.dart';



// Register Cubit
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());
  
  Future<void> signUp(String name, String email, String password) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        emit(state.copyWith(status: RegisterStatus.success));
      } else {
        emit(state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please fill all fields',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  void reset() {
    emit(const RegisterState());
  }
}