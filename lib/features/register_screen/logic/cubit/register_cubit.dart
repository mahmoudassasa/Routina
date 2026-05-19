import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routina/features/register_screen/logic/cubit/register_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  final ImagePicker _picker = ImagePicker();
  final supabase = Supabase.instance.client;

  /// Pick image from gallery
  Future<void> pickImage() async {
    emit(state.copyWith(imageStatus: ImageUploadStatus.picking));

    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      emit(
        state.copyWith(
          localImage: File(picked.path),
          imageStatus: ImageUploadStatus.success,
        ),
      );
    } else {
      emit(state.copyWith(imageStatus: ImageUploadStatus.initial));
    }
  }

  /// Upload image to Supabase
  Future<String?> uploadImage(String uid) async {
    if (state.localImage == null) return null;

    try {
      emit(state.copyWith(imageStatus: ImageUploadStatus.uploading));

      final fileName =
          "$uid-profile-${DateTime.now().millisecondsSinceEpoch}.jpg";

      await supabase.storage
          .from('users')
          .upload(
            fileName,
            state.localImage!,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      final imageUrl = supabase.storage.from('users').getPublicUrl(fileName);

      emit(
        state.copyWith(
          imageStatus: ImageUploadStatus.success,
          imageUrl: imageUrl,
        ),
      );

      return imageUrl;
    } catch (e) {
      emit(
        state.copyWith(
          imageStatus: ImageUploadStatus.error,
          errorMessage: e.toString(),
        ),
      );
      return null;
    }
  }

  /// Full register process
  Future<void> register(String name, String email, String password) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;
      await userCredential.user!.sendEmailVerification();

      String? imageUrl = await uploadImage(uid);
      imageUrl ??=
          "https://gvqgliulacfmhscswyid.supabase.co/storage/v1/object/public/users/unknown.png";

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
        'createdAt': DateTime.now(),
      });

      emit(state.copyWith(status: RegisterStatus.success));
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorCode: _mapError(e.code),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorCode: 'unexpectedError',
        ),
      );
    }
  }

  String _mapError(String code) {
    return switch (code) {
      'email-already-in-use' => 'emailAlreadyInUse',
      'invalid-email' => 'invalidEmail',
      'weak-password' => 'weakPassword',
      'operation-not-allowed' => 'operationNotAllowed',
      'network-request-failed' => 'networkError',
      _ => 'unexpectedError',
    };
  }
}
