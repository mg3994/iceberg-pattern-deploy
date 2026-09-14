import 'package:firebase_auth/firebase_auth.dart' show User, UserCredential;
import 'package:signals_core/signals_core.dart';

abstract interface class AuthRepository {
  /// Submerged reactive signal of current auth user snapshot
  ReadonlySignal<User?> get currentUser;

  /// Underlying raw stream for internal subscriptions
  Stream<User?> get authStateChanges;

  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
