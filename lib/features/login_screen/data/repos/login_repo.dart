import 'package:firebase_auth/firebase_auth.dart';

class LoginRepo {
  final FirebaseAuth _firebaseAuth;
  LoginRepo(this._firebaseAuth);

  Future<UserCredential> signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
