import 'package:material_ui/material_ui.dart' show FlutterErrorDetails;

abstract interface class CrashReporter {
  /// Submits a Crashlytics report of a caught error.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  });

  //
  Future<void> recordFlutterError(
    FlutterErrorDetails flutterErrorDetails, {
    bool fatal = false,
  });
  Future<void> recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails);
}
