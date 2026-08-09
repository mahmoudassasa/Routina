import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routina/core/services/premium_service.dart';
import 'package:routina/features/register_screen/logic/cubit/register_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    ImagePicker? picker,
    GoogleSignIn? googleSignIn,
    PremiumService? premiumService,
  })  : _picker = picker ?? ImagePicker(),
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _premiumService = premiumService ?? PremiumService(),
        super(const RegisterState());

  final ImagePicker _picker;
  final GoogleSignIn _googleSignIn;
  final PremiumService _premiumService;
  final _supabase = Supabase.instance.client;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    emit(state.copyWith(imageStatus: ImageUploadStatus.picking));
    try {
      final picked = await _picker.pickImage(source: source);

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
    } catch (e) {
      emit(
        state.copyWith(
          imageStatus: ImageUploadStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<String?> uploadImage(String uid) async {
    if (state.localImage == null) return null;

    try {
      emit(state.copyWith(imageStatus: ImageUploadStatus.uploading));

      final fileName = "$uid-profile-${DateTime.now().millisecondsSinceEpoch}.jpg";

      await _supabase.storage.from('users').upload(
            fileName,
            state.localImage!,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      final imageUrl = _supabase.storage.from('users').getPublicUrl(fileName);

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

  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
    String dob,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    UserCredential? userCredential;
    String? imageUrl;

    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;

      imageUrl = await uploadImage(uid);
      imageUrl ??= _supabase.storage.from('users').getPublicUrl('unknown.png');

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'dob': dob,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _premiumService.ensurePremiumRecord();
      await userCredential.user!.sendEmailVerification();

      emit(state.copyWith(status: RegisterStatus.success));
    } catch (e) {
      await _rollbackRegistration(userCredential?.user, imageUrl);

      final errorCode = (e is FirebaseAuthException)
          ? _mapError(e.code)
          : 'unexpectedError';

      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorCode: errorCode,
        ),
      );
    }
  }

  Future<void> _rollbackRegistration(User? user, String? imageUrl) async {
    if (user == null) return;
    final uid = user.uid;

    try {
      await user.delete();
    } catch (_) {}

    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (_) {}

    if (imageUrl != null && imageUrl.contains(uid)) {
      try {
        final fileName = imageUrl.split('/').last;
        await _supabase.storage.from('users').remove([fileName]);
      } catch (_) {}
    }
  }

  Future<void> registerWithGoogle() async {
    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        emit(state.copyWith(status: RegisterStatus.initial));
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final String uid = user.uid;

        String? imageUrl = await uploadImage(uid);
        imageUrl ??= user.photoURL ?? _supabase.storage.from('users').getPublicUrl('unknown.png');

        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'name': user.displayName ?? 'Google User',
          'email': user.email ?? '',
          'imageUrl': imageUrl,
          'phone': user.phoneNumber ?? '',
          'dob': '',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        await _premiumService.ensurePremiumRecord();

        emit(state.copyWith(status: RegisterStatus.success));
      } else {
        emit(
          state.copyWith(
            status: RegisterStatus.error,
            errorCode: 'unexpectedError',
          ),
        );
      }
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