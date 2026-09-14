import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Top-level function required by Firebase Cloud Messaging.
/// Needs `@pragma('vm:entry-point')` to prevent Dart AOT tree-shaking in release mode.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Must initialize Firebase within this separate Dart isolate
  await Firebase.initializeApp();

  // Perform background data processing (e.g., local storage sync, caching)
}
