import 'package:material_ui/material_ui.dart' show ThemeMode;

/// Pure Dart 3 Record Typedef representation of AppSetting entity.
typedef AppSetting = ({
  int id,
  ThemeMode themeMode,
  String languageCode,
  int seedColor,
  bool hasCompletedOnboarding,
  bool hasGivenConsent,
  bool analyticsStorageConsentGranted,
  bool adStorageConsentGranted,
  bool adUserDataConsentGranted,
  bool adPersonalizationSignalsConsentGranted,
  bool functionalityStorageConsentGranted,
  bool personalizationStorageConsentGranted,
  bool securityStorageConsentGranted,
});
