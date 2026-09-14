part of 'app_setting_bloc.dart';

class AppSettingState {
  final ThemeMode themeMode;
  final Locale locale;
  final Color seedColor;
  final bool hasCompletedOnboarding;
  final bool hasGivenConsent;
  final bool analyticsStorageConsentGranted;
  final bool adStorageConsentGranted;
  final bool adUserDataConsentGranted;
  final bool adPersonalizationSignalsConsentGranted;
  final bool functionalityStorageConsentGranted;
  final bool personalizationStorageConsentGranted;
  final bool securityStorageConsentGranted;

  const AppSettingState({
    required this.themeMode,
    required this.locale,
    required this.seedColor,
    this.hasCompletedOnboarding = false,
    this.hasGivenConsent = false,
    this.analyticsStorageConsentGranted = false,
    this.adStorageConsentGranted = false,
    this.adUserDataConsentGranted = false,
    this.adPersonalizationSignalsConsentGranted = false,
    this.functionalityStorageConsentGranted = true,
    this.personalizationStorageConsentGranted = false,
    this.securityStorageConsentGranted = true,
  });

  AppSettingState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
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
  }) {
    return AppSettingState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      seedColor: seedColor ?? this.seedColor,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      hasGivenConsent: hasGivenConsent ?? this.hasGivenConsent,
      analyticsStorageConsentGranted:
          analyticsStorageConsentGranted ?? this.analyticsStorageConsentGranted,
      adStorageConsentGranted:
          adStorageConsentGranted ?? this.adStorageConsentGranted,
      adUserDataConsentGranted:
          adUserDataConsentGranted ?? this.adUserDataConsentGranted,
      adPersonalizationSignalsConsentGranted:
          adPersonalizationSignalsConsentGranted ??
          this.adPersonalizationSignalsConsentGranted,
      functionalityStorageConsentGranted:
          functionalityStorageConsentGranted ??
          this.functionalityStorageConsentGranted,
      personalizationStorageConsentGranted:
          personalizationStorageConsentGranted ??
          this.personalizationStorageConsentGranted,
      securityStorageConsentGranted:
          securityStorageConsentGranted ?? this.securityStorageConsentGranted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingState &&
        other.themeMode == themeMode &&
        other.locale == locale &&
        other.seedColor == seedColor &&
        other.hasCompletedOnboarding == hasCompletedOnboarding &&
        other.hasGivenConsent == hasGivenConsent &&
        other.analyticsStorageConsentGranted ==
            analyticsStorageConsentGranted &&
        other.adStorageConsentGranted == adStorageConsentGranted &&
        other.adUserDataConsentGranted == adUserDataConsentGranted &&
        other.adPersonalizationSignalsConsentGranted ==
            adPersonalizationSignalsConsentGranted &&
        other.functionalityStorageConsentGranted ==
            functionalityStorageConsentGranted &&
        other.personalizationStorageConsentGranted ==
            personalizationStorageConsentGranted &&
        other.securityStorageConsentGranted == securityStorageConsentGranted;
  }

  @override
  int get hashCode => Object.hash(
    themeMode,
    locale,
    seedColor,
    hasCompletedOnboarding,
    hasGivenConsent,
    analyticsStorageConsentGranted,
    adStorageConsentGranted,
    adUserDataConsentGranted,
    adPersonalizationSignalsConsentGranted,
    functionalityStorageConsentGranted,
    personalizationStorageConsentGranted,
    securityStorageConsentGranted,
  );
  AppSettingState defaultState() => AppSettingState(
    themeMode: AppConfig.defaultThemeMode,
    locale: AppConfig.defaultLocale,
    seedColor: Color(AppConfig.defaultThemeSeedColorHex),
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
