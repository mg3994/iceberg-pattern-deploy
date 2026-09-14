import 'package:firebase_auth/firebase_auth.dart' show User;

abstract interface class SocialAuthGateway {
  Future<User?> signInWithGoogle();
}
