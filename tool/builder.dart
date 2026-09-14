import 'package:build/build.dart';

class CopyCompiledJs extends Builder {
  CopyCompiledJs([BuilderOptions? options]);

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final outputId = buildStep.allowedOutputs.single;

    final input = await buildStep.readAsBytes(inputId);
    await buildStep.writeAsBytes(outputId, input);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    'web/worker.dart.js': ['web/drift_worker.js'],
    'web/firebase_messaging_sw.dart.js': ['web/firebase-messaging-sw.js'],
  };
}
