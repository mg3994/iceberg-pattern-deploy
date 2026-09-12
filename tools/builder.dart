import 'package:build/build.dart';

class CopyCompiledJs extends Builder {
  CopyCompiledJs([BuilderOptions? options]);

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final outputId = buildStep.allowedOutputs.single;
    final compiledId = AssetId(inputId.package, '${inputId.path}.js');

    final compiledWorker = await buildStep.readAsBytes(compiledId);
    await buildStep.writeAsBytes(outputId, compiledWorker);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    'tools/drift_worker.dart': ['apps/blogstore/web/drift_worker.js'],
  };
}