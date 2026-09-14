import 'package:material_ui/material_ui.dart' show Locale;

import '../repositories/app_setting_repository.dart';

final class TemporarilyChangeLocaleUseCase {
  const TemporarilyChangeLocaleUseCase(this._repository);

  final AppSettingRepository _repository;

  Future<void> call(Locale locale) =>
      _repository.temporarilyChangeLocale(locale);
}
