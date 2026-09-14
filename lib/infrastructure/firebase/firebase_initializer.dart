import '../../firebase_options.dart' show DefaultFirebaseOptions;

import 'package:firebase_core/firebase_core.dart';

abstract interface class FirebaseInitializer {
  Future<FirebaseApp> initialize();
}

final class DefaultFirebaseInitializer implements FirebaseInitializer {
  const DefaultFirebaseInitializer();

  @override
  Future<FirebaseApp> initialize() =>
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
