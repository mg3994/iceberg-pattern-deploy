import 'package:firebase_auth/firebase_auth.dart';

import '../../core/auth/access_token_provider.dart';

final class FirebaseAccessTokenProvider implements AccessTokenProvider {
  const FirebaseAccessTokenProvider(this._auth);

  final FirebaseAuth _auth;

  @override
  Future<String?> getAccessToken() async {
    return _auth.currentUser?.getIdToken();
  }
}
