import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/features/register_screen/logic/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  Future<void> register(String name, String email, String password) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      // 1) Create account
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      final uid = user.uid;

      // 2) Send Email Verification
      await user.sendEmailVerification();

      // 3) Save User in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': DateTime.now(),
      });

      // ❌ Remove this! (Important)
      // await FirebaseAuth.instance.signOut();

      emit(state.copyWith(status: RegisterStatus.success));
      
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
