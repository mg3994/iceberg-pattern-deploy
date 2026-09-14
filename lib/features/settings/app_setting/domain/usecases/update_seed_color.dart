import 'package:material_ui/material_ui.dart' show Color;

import '../repositories/app_setting_repository.dart';

final class UpdateSeedColorUseCase {
  const UpdateSeedColorUseCase(this._repository);

  final AppSettingRepository _repository;

  Future<void> call(Color seedColor) => _repository.updateSeedColor(seedColor);
}
