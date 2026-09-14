import '../repositories/app_setting_repository.dart';

final class UpdateConsentUseCase {
  const UpdateConsentUseCase(this._repository);

  final AppSettingRepository _repository;

  Future<void> call({
    required bool hasGivenConsent,
    required bool analyticsStorageConsentGranted,
    required bool adStorageConsentGranted,
    required bool adUserDataConsentGranted,
    required bool adPersonalizationSignalsConsentGranted,
    required bool functionalityStorageConsentGranted,
    required bool personalizationStorageConsentGranted,
    required bool securityStorageConsentGranted,
  }) => _repository.updateConsent(
    hasGivenConsent: hasGivenConsent,
    analyticsStorageConsentGranted: analyticsStorageConsentGranted,
    adStorageConsentGranted: adStorageConsentGranted,
    adUserDataConsentGranted: adUserDataConsentGranted,
    adPersonalizationSignalsConsentGranted:
        adPersonalizationSignalsConsentGranted,
    functionalityStorageConsentGranted: functionalityStorageConsentGranted,
    personalizationStorageConsentGranted: personalizationStorageConsentGranted,
    securityStorageConsentGranted: securityStorageConsentGranted,
  );
}
