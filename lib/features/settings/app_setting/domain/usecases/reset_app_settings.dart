import '../repositories/app_setting_repository.dart';

final class ResetAppSettingsUseCase {
  const ResetAppSettingsUseCase(this._repository);

  final AppSettingRepository _repository;

  Future<void> call() => _repository.resetToDefaultAppSettings();
}
