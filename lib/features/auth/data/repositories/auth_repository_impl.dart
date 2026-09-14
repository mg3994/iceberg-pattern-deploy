import 'package:firebase_auth/firebase_auth.dart' show User, UserCredential;
import 'package:signals_core/signals_core.dart';

import '../../../../core/auth/auth_gateway.dart';
import '../../domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._gateway) {
    _userSignal = streamSignal(
      () => _gateway.authStateChanges,
    );
  }

  final AuthGateway _gateway;
  late final StreamSignal<User?> _userSignal;

  @override
  ReadonlySignal<User?> get currentUser => _userSignal;

  @override
  Stream<User?> get authStateChanges => _gateway.authStateChanges;

  @override
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _gateway.signInWithEmail(email: email, password: password);
  }

  @override
  Future<void> signOut() => _gateway.signOut();
}
