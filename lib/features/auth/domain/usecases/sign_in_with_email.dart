import 'package:firebase_auth/firebase_auth.dart' show UserCredential;

import '../repositories/auth_repository.dart';

final class SignInWithEmail {
  const SignInWithEmail(this._repository);

  final AuthRepository _repository;

  Future<UserCredential?> call({
    required String email,
    required String password,
  }) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}
