///Try replacing your firebase_options code with this
///
// static const FirebaseOptions web = FirebaseOptions(
//   apiKey: FirebaseWebConfig.apiKey,
//   appId: FirebaseWebConfig.appId,
//   messagingSenderId: FirebaseWebConfig.messagingSenderId,
//   projectId: FirebaseWebConfig.projectId,
//   authDomain: FirebaseWebConfig.authDomain,
//   storageBucket: FirebaseWebConfig.storageBucket,
//   measurementId: FirebaseWebConfig.measurementId,
// );

// lib/firebase_web_config.dart
// put all those firebase config web stuff one by one here
abstract final class FirebaseWebConfig {
  static const String apiKey = 'AIzaSyAUtirDdNPTmQz0Ze4lZ_r6du48HdpJIxQ';
  static const String authDomain = 'rotiride.firebaseapp.com';
  static const String projectId = 'rotiride';
  static const String storageBucket = 'rotiride.firebasestorage.app';
  static const String messagingSenderId = '318526800636';
  static const String appId = '1:318526800636:web:3388facad20b50c3abcd79';
  static const String measurementId = "G-EX30SN5FR5";
  static const String? serviceWorkerScriptPath = '/firebase-messaging-sw.js';
  static const String? vapidKey = "";
}
