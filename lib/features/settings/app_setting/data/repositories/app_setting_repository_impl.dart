import 'package:material_ui/material_ui.dart' show Color, Locale, ThemeMode;

import '../../../../../core/analytics/analytics_gateway.dart';
import '../../domain/entities/app_setting.dart' show AppSetting;
import '../../domain/repositories/app_setting_repository.dart'
    show AppSettingRepository;
import '../datasources/local/app_setting_local_datasource.dart'
    show AppSettingLocalDataSource;

final class AppSettingRepositoryImpl implements AppSettingRepository {
  const AppSettingRepositoryImpl({
    required this._localDataSource,
    this._analyticsGateway,
  });

  final AppSettingLocalDataSource _localDataSource;
  final AnalyticsGateway? _analyticsGateway;

  @override
  Future<AppSetting> getSettings() => _localDataSource.loadSettings();

  @override
  Stream<AppSetting> watchSettings() => _localDataSource.watchSettings();

  @override
  Future<void> resetToDefaultAppSettings() async {
    await _localDataSource.resetToDefaultSettings();
    await _analyticsGateway?.logEvent(
      name: 'app_settings_reset_to_default',
      parameters: {'is_default': 'true'},
    );
  }

  @override
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await _localDataSource.updateSettings(themeMode: themeMode);
    await _analyticsGateway?.logEvent(
      name: 'theme_mode_changed',
      parameters: {'theme_mode': themeMode.name, 'is_temporary': 'false'},
    );
  }

  @override
  Future<void> updateLocale(Locale locale) async {
    await _localDataSource.updateSettings(languageCode: locale.languageCode);
    await _analyticsGateway?.logEvent(
      name: 'locale_changed',
      parameters: {
        'language_code': locale.languageCode,
        'is_temporary': 'false',
      },
    );
  }

  @override
  Future<void> updateSeedColor(Color seedColor) async {
    await _localDataSource.updateSettings(seedColor: seedColor);
    await _analyticsGateway?.logEvent(
      name: 'seed_color_changed',
      parameters: {
        'seed_color': seedColor.toARGB32().toRadixString(16),
        'is_temporary': 'false',
      },
    );
  }

  @override
  Future<void> updateConsent({
    required bool hasGivenConsent,
    required bool analyticsStorageConsentGranted,
    required bool adStorageConsentGranted,
    required bool adUserDataConsentGranted,
    required bool adPersonalizationSignalsConsentGranted,
    required bool functionalityStorageConsentGranted,
    required bool personalizationStorageConsentGranted,
    required bool securityStorageConsentGranted,
  }) async {
    await _localDataSource.updateSettings(
      hasGivenConsent: hasGivenConsent,
      analyticsStorageConsentGranted: analyticsStorageConsentGranted,
      adStorageConsentGranted: adStorageConsentGranted,
      adUserDataConsentGranted: adUserDataConsentGranted,
      adPersonalizationSignalsConsentGranted:
          adPersonalizationSignalsConsentGranted,
      functionalityStorageConsentGranted: functionalityStorageConsentGranted,
      personalizationStorageConsentGranted:
          personalizationStorageConsentGranted,
      securityStorageConsentGranted: securityStorageConsentGranted,
    );
    await _analyticsGateway?.setConsent(
      analyticsStorageConsentGranted: analyticsStorageConsentGranted,
      adStorageConsentGranted: adStorageConsentGranted,
      adUserDataConsentGranted: adUserDataConsentGranted,
      adPersonalizationSignalsConsentGranted:
          adPersonalizationSignalsConsentGranted,
      functionalityStorageConsentGranted: functionalityStorageConsentGranted,
      personalizationStorageConsentGranted:
          personalizationStorageConsentGranted,
      securityStorageConsentGranted: securityStorageConsentGranted,
    );
    // in place of this
    await _analyticsGateway?.logEvent(
      name: 'consent_updated',
      parameters: {
        'analytics': analyticsStorageConsentGranted.toString(),
        'ad_storage': adStorageConsentGranted.toString(),
      },
    );
  }

  @override
  Future<void> updateOnboardingCompleted(bool completed) async {
    await _localDataSource.updateSettings(hasCompletedOnboarding: completed);
    if (completed) {
      await _analyticsGateway?.logTutorialComplete();
    } else {
      await _analyticsGateway?.logTutorialBegin();
    }
  }

  ////
  @override
  Future<void> temporarilyChangeLocale(Locale locale) async {
    await _analyticsGateway?.logEvent(
      name: 'locale_changed',
      parameters: {
        'language_code': locale.languageCode,
        'is_temporary': 'true',
      },
    );
  }

  @override
  Future<void> temporarilyChangeSeedColor(Color seedColor) async {
    await _analyticsGateway?.logEvent(
      name: 'seed_color_changed',
      parameters: {
        'seed_color': seedColor.toARGB32().toRadixString(16),
        'is_temporary': 'true',
      },
    );
  }

  @override
  Future<void> temporarilyChangeThemeMode(ThemeMode themeMode) async {
    await _analyticsGateway?.logEvent(
      name: 'theme_mode_changed',
      parameters: {'theme_mode': themeMode.name, 'is_temporary': 'true'},
    );
  }

  ///
}
