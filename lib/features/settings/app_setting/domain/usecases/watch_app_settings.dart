import '../entities/app_setting.dart';
import '../repositories/app_setting_repository.dart';

final class WatchAppSettingsUseCase {
  const WatchAppSettingsUseCase(this._repository);

  final AppSettingRepository _repository;

  Stream<AppSetting> call() => _repository.watchSettings();
}
