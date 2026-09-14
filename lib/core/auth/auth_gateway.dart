import 'package:firebase_auth/firebase_auth.dart' show User, UserCredential;

abstract interface class AuthGateway {
  Stream<User?> get authStateChanges;

  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
