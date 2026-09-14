import '../repositories/app_setting_repository.dart';

final class UpdateOnboardingCompletedUseCase {
  const UpdateOnboardingCompletedUseCase(this._repository);

  final AppSettingRepository _repository;

  Future<void> call(bool completed) =>
      _repository.updateOnboardingCompleted(completed);
}
