import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(const DeleteAccountState());

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _supabase = Supabase.instance.client;

  bool get isGoogleUser =>
      _auth.currentUser?.providerData.any(
        (p) => p.providerId == 'google.com',
      ) ??
      false;

  Future<void> deleteAccount({String? email, String? password}) async {
    emit(state.copyWith(status: DeleteAccountStatus.loading));

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final uid = user.uid;

      // Step 1: Re-authenticate
      await _reauthenticate(user: user, email: email, password: password);

      // Step 2: Delete Supabase habits
      await _supabase.from('habits').delete().eq('user_id', uid);

      // Step 3: Delete Supabase Storage (profile image)
      await _deleteSupabaseImage(uid);

      // Step 4: Delete Firestore user doc — قبل Firebase Auth
      await _firestore.collection('users').doc(uid).delete();

      // Step 5: Delete Firebase Auth — آخر حاجة
      await user.delete();

      emit(state.copyWith(status: DeleteAccountStatus.success));
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(
        state.copyWith(status: DeleteAccountStatus.error, errorCode: e.code),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DeleteAccountStatus.error,
          errorCode: 'unexpected',
        ),
      );
    }
  }

  Future<void> _reauthenticate({
    required firebase_auth.User user,
    String? email,
    String? password,
  }) async {
    if (isGoogleUser) {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw FirebaseAuthException(code: 'cancelled');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await user.reauthenticateWithCredential(credential);
    } else {
      if (email == null || password == null) {
        throw FirebaseAuthException(code: 'missing-credentials');
      }
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    }
  }

Future<void> _deleteSupabaseImage(String uid) async {
  try {
    final files = await _supabase.storage.from('users').list();
    
    final userFiles = files
        .where((f) => f.name.startsWith('$uid-profile-'))
        .map((f) => f.name)
        .toList();
    
    
    if (userFiles.isNotEmpty) {
      await _supabase.storage.from('users').remove(userFiles);
    }
  } catch (e) {
    // Log the error but don't fail the whole deletion process
  }
}
}
