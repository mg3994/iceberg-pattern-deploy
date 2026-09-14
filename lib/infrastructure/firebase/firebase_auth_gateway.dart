import 'package:firebase_auth/firebase_auth.dart';

import '../../core/auth/auth_gateway.dart';

final class FirebaseAuthGateway implements AuthGateway {
  FirebaseAuthGateway(this._auth);

  final FirebaseAuth _auth;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges(); //.map((user) => user);

  @override
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential;
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
