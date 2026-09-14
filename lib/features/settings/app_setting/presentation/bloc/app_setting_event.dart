part of 'app_setting_bloc.dart';

sealed class AppSettingEvent {
  const AppSettingEvent();
}

final class GetAppSettingEvent extends AppSettingEvent {
  const GetAppSettingEvent();
}

final class AppSettingUpdateThemeModeEvent extends AppSettingEvent {
  const AppSettingUpdateThemeModeEvent(this.themeMode);
  final ThemeMode themeMode;
}

final class AppSettingTemporarilyChangeThemeModeEvent extends AppSettingEvent {
  const AppSettingTemporarilyChangeThemeModeEvent(this.themeMode);
  final ThemeMode themeMode;
}

final class AppSettingUpdateLocaleEvent extends AppSettingEvent {
  const AppSettingUpdateLocaleEvent(this.locale);
  final Locale locale;
}

final class AppSettingTemporarilyChangeLocaleEvent extends AppSettingEvent {
  const AppSettingTemporarilyChangeLocaleEvent(this.locale);
  final Locale locale;
}

final class AppSettingUpdateSeedColorEvent extends AppSettingEvent {
  const AppSettingUpdateSeedColorEvent(this.seedColor);
  final Color seedColor;
}

final class AppSettingTemporarilyChangeSeedColorEvent extends AppSettingEvent {
  const AppSettingTemporarilyChangeSeedColorEvent(this.seedColor);
  final Color seedColor;
}

final class AppSettingResetToDefaultEvent extends AppSettingEvent {
  const AppSettingResetToDefaultEvent();
}

final class AppSettingOnboardingEvent extends AppSettingEvent {
  final bool isCompleted;
  const AppSettingOnboardingEvent({required this.isCompleted});
}

final class AppSettingUpdateConsentEvent extends AppSettingEvent {
  const AppSettingUpdateConsentEvent({
    required this.hasGivenConsent,
    required this.analyticsStorageConsentGranted,
    required this.adStorageConsentGranted,
    required this.adUserDataConsentGranted,
    required this.adPersonalizationSignalsConsentGranted,
    required this.functionalityStorageConsentGranted,
    required this.personalizationStorageConsentGranted,
    required this.securityStorageConsentGranted,
  });

  final bool hasGivenConsent;
  final bool analyticsStorageConsentGranted;
  final bool adStorageConsentGranted;
  final bool adUserDataConsentGranted;
  final bool adPersonalizationSignalsConsentGranted;
  final bool functionalityStorageConsentGranted;
  final bool personalizationStorageConsentGranted;
  final bool securityStorageConsentGranted;
}

// final class AppSettingShowConsentPromptEvent extends AppSettingEvent {
//   const AppSettingShowConsentPromptEvent();
// }

// final class AppSettingDismissConsentPromptEvent extends AppSettingEvent {
//   const AppSettingDismissConsentPromptEvent();
// }
