import 'package:material_ui/material_ui.dart' show ThemeMode;

import '../repositories/app_setting_repository.dart';

final class UpdateThemeModeUseCase {
  const UpdateThemeModeUseCase(this._repository);

  final AppSettingRepository _repository;

  Future<void> call(ThemeMode themeMode) =>
      _repository.updateThemeMode(themeMode);
}
