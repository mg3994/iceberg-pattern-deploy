import 'package:drift/drift.dart';
import 'package:material_ui/material_ui.dart' show Color, ThemeMode;

import '../../../../../../config/app_config.dart' show AppConfig;
import '../../../../../../infrastructure/database/drift/app_database.dart'
    show AppDatabase, AppSettingsCompanion;
import '../../../domain/entities/app_setting.dart' show AppSetting;

abstract interface class AppSettingLocalDataSource {
  Future<AppSetting> loadSettings();
  Stream<AppSetting> watchSettings();
  Future<void> resetToDefaultSettings();
  Future<void> updateSettings({
    ThemeMode? themeMode,
    String? languageCode,
    Color? seedColor,
    bool? hasCompletedOnboarding,
    bool? hasGivenConsent,
    bool? analyticsStorageConsentGranted,
    bool? adStorageConsentGranted,
    bool? adUserDataConsentGranted,
    bool? adPersonalizationSignalsConsentGranted,
    bool? functionalityStorageConsentGranted,
    bool? personalizationStorageConsentGranted,
    bool? securityStorageConsentGranted,
  });
}

final class AppSettingLocalDataSourceImpl implements AppSettingLocalDataSource {
  const AppSettingLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<AppSetting> loadSettings() async {
    final setting = await (_db.select(
      _db.appSettings,
    )..where((t) => t.id.equals(1))).getSingleOrNull();

    if (setting == null) {
      return AppSetting(
        id: 1,
        themeMode: AppConfig.defaultThemeMode,
        languageCode: AppConfig.defaultLocale.languageCode,
        seedColor: AppConfig.defaultThemeSeedColorHex,
        hasCompletedOnboarding: false,
        hasGivenConsent: false,
        analyticsStorageConsentGranted: false,
        adStorageConsentGranted: false,
        adUserDataConsentGranted: false,
        adPersonalizationSignalsConsentGranted: false,
        functionalityStorageConsentGranted: true,
        personalizationStorageConsentGranted: false,
        securityStorageConsentGranted: true,
      );
    }

    return AppSetting(
      id: setting.id,
      themeMode: setting.themeMode,
      languageCode: setting.languageCode,
      seedColor: setting.seedColor,
      hasCompletedOnboarding: setting.hasCompletedOnboarding,
      hasGivenConsent: setting.hasGivenConsent,
      analyticsStorageConsentGranted: setting.analyticsStorageConsentGranted,
      adStorageConsentGranted: setting.adStorageConsentGranted,
      adUserDataConsentGranted: setting.adUserDataConsentGranted,
      adPersonalizationSignalsConsentGranted:
          setting.adPersonalizationSignalsConsentGranted,
      functionalityStorageConsentGranted:
          setting.functionalityStorageConsentGranted,
      personalizationStorageConsentGranted:
          setting.personalizationStorageConsentGranted,
      securityStorageConsentGranted: setting.securityStorageConsentGranted,
    );
  }

  @override
  Stream<AppSetting> watchSettings() {
    return (_db.select(
      _db.appSettings,
    )..where((t) => t.id.equals(1))).watchSingleOrNull().map((setting) {
      if (setting == null) {
        return AppSetting(
          id: 1,
          themeMode: AppConfig.defaultThemeMode,
          languageCode: AppConfig.defaultLocale.languageCode,
          seedColor: AppConfig.defaultThemeSeedColorHex,
          hasCompletedOnboarding: false,
          hasGivenConsent: false,
          analyticsStorageConsentGranted: false,
          adStorageConsentGranted: false,
          adUserDataConsentGranted: false,
          adPersonalizationSignalsConsentGranted: false,
          functionalityStorageConsentGranted: true,
          personalizationStorageConsentGranted: false,
          securityStorageConsentGranted: true,
        );
      }
      return AppSetting(
        id: setting.id,
        themeMode: setting.themeMode,
        languageCode: setting.languageCode,
        seedColor: setting.seedColor,
        hasCompletedOnboarding: setting.hasCompletedOnboarding,
        hasGivenConsent: setting.hasGivenConsent,
        analyticsStorageConsentGranted: setting.analyticsStorageConsentGranted,
        adStorageConsentGranted: setting.adStorageConsentGranted,
        adUserDataConsentGranted: setting.adUserDataConsentGranted,
        adPersonalizationSignalsConsentGranted:
            setting.adPersonalizationSignalsConsentGranted,
        functionalityStorageConsentGranted:
            setting.functionalityStorageConsentGranted,
        personalizationStorageConsentGranted:
            setting.personalizationStorageConsentGranted,
        securityStorageConsentGranted: setting.securityStorageConsentGranted,
      );
    });
  }

  @override
  Future<void> resetToDefaultSettings() async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion(
            id: const Value(1),
            themeMode: Value(AppConfig.defaultThemeMode),
            languageCode: Value(AppConfig.defaultLocale.languageCode),
            seedColor: Value(AppConfig.defaultThemeSeedColorHex),
            hasCompletedOnboarding: const Value(false),
            hasGivenConsent: const Value(false),
            analyticsStorageConsentGranted: const Value(false),
            adStorageConsentGranted: const Value(false),
            adUserDataConsentGranted: const Value(false),
            adPersonalizationSignalsConsentGranted: const Value(false),
            functionalityStorageConsentGranted: const Value(true),
            personalizationStorageConsentGranted: const Value(false),
            securityStorageConsentGranted: const Value(true),
          ),
        );
  }

  @override
  Future<void> updateSettings({
    ThemeMode? themeMode,
    String? languageCode,
    Color? seedColor,
    bool? hasCompletedOnboarding,
    bool? hasGivenConsent,
    bool? analyticsStorageConsentGranted,
    bool? adStorageConsentGranted,
    bool? adUserDataConsentGranted,
    bool? adPersonalizationSignalsConsentGranted,
    bool? functionalityStorageConsentGranted,
    bool? personalizationStorageConsentGranted,
    bool? securityStorageConsentGranted,
  }) async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion(
            id: const Value(1),
            themeMode: themeMode != null
                ? Value(themeMode)
                : const Value.absent(),
            languageCode: languageCode != null
                ? Value(languageCode)
                : const Value.absent(),
            seedColor: seedColor != null
                ? Value(seedColor.toARGB32())
                : const Value.absent(),
            hasCompletedOnboarding: hasCompletedOnboarding != null
                ? Value(hasCompletedOnboarding)
                : const Value.absent(),
            hasGivenConsent: hasGivenConsent != null
                ? Value(hasGivenConsent)
                : const Value.absent(),
            analyticsStorageConsentGranted:
                analyticsStorageConsentGranted != null
                ? Value(analyticsStorageConsentGranted)
                : const Value.absent(),
            adStorageConsentGranted: adStorageConsentGranted != null
                ? Value(adStorageConsentGranted)
                : const Value.absent(),
            adUserDataConsentGranted: adUserDataConsentGranted != null
                ? Value(adUserDataConsentGranted)
                : const Value.absent(),
            adPersonalizationSignalsConsentGranted:
                adPersonalizationSignalsConsentGranted != null
                ? Value(adPersonalizationSignalsConsentGranted)
                : const Value.absent(),
            functionalityStorageConsentGranted:
                functionalityStorageConsentGranted != null
                ? Value(functionalityStorageConsentGranted)
                : const Value.absent(),
            personalizationStorageConsentGranted:
                personalizationStorageConsentGranted != null
                ? Value(personalizationStorageConsentGranted)
                : const Value.absent(),
            securityStorageConsentGranted: securityStorageConsentGranted != null
                ? Value(securityStorageConsentGranted)
                : const Value.absent(),
          ),
        );
  }
}
