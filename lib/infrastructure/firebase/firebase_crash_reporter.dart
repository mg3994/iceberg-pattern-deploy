import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart'; // Gives you kIsWeb

import '../../core/monitoring/crash_reporter.dart';

final class FirebaseCrashReporter implements CrashReporter {
  // 1. Make this nullable so you can pass null when running on Web
  FirebaseCrashReporter(this._crashlytics);

  final FirebaseCrashlytics? _crashlytics;

  @override
  /// Submits a Crashlytics report of a caught error.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {
    // 2. Safely return early if on the web or if crashlytics wasn't provided
    if (kIsWeb || _crashlytics == null) return;

    return _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
  }

  @override
  Future<void> recordFlutterError(
    FlutterErrorDetails flutterErrorDetails, {
    bool fatal = false,
  }) async {
    if (kIsWeb || _crashlytics == null) return;

    return _crashlytics.recordFlutterError(flutterErrorDetails, fatal: fatal);
  }

  @override
  Future<void> recordFlutterFatalError(
    FlutterErrorDetails flutterErrorDetails,
  ) async {
    if (kIsWeb || _crashlytics == null) return;

    return _crashlytics.recordFlutterError(flutterErrorDetails, fatal: true);
  }
}
