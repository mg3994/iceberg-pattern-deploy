import 'package:material_ui/material_ui.dart' show Color, Locale, ThemeMode;

import '../entities/app_setting.dart';

abstract interface class AppSettingRepository {
  Future<AppSetting> getSettings();
  Stream<AppSetting> watchSettings();
  Future<void> resetToDefaultAppSettings();
  Future<void> updateThemeMode(ThemeMode themeMode);
  Future<void> updateLocale(Locale locale);
  Future<void> updateSeedColor(Color seedColor);
  Future<void> updateOnboardingCompleted(bool completed);
  Future<void> updateConsent({
    required bool hasGivenConsent,
    required bool analyticsStorageConsentGranted,
    required bool adStorageConsentGranted,
    required bool adUserDataConsentGranted,
    required bool adPersonalizationSignalsConsentGranted,
    required bool functionalityStorageConsentGranted,
    required bool personalizationStorageConsentGranted,
    required bool securityStorageConsentGranted,
  });
  //TODO: Remove beow
  Future<void> temporarilyChangeThemeMode(ThemeMode themeMode);
  Future<void> temporarilyChangeLocale(Locale locale);
  Future<void> temporarilyChangeSeedColor(Color seedColor);
}
