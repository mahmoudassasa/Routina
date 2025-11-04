import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/features/register_screen/logic/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  Future<void> signUp(String name, String email, String password) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      // Create the user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the display name
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();

      emit(state.copyWith(status: RegisterStatus.success));
    } on FirebaseAuthException catch (e) {
      String message = '';

      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak 🔒';
          break;
        case 'email-already-in-use':
          message = 'Email-already-in-use 📧';
          break;
        default:
          message = 'An error occurred, please try again.';
      }

      emit(state.copyWith(status: RegisterStatus.error, errorMessage: message));
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.error,
        errorMessage: 'An unexpected error occurred: $e',
      ));
    }
  }

  void reset() {
    emit(const RegisterState());
  }
}
