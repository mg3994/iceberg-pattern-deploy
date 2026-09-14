import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:material_ui/material_ui.dart'
    show Color, Colors, Locale, ThemeMode;

import '../../../../../config/app_config.dart' show AppConfig;
import '../../../../../core/monitoring/crash_reporter.dart' show CrashReporter;
import '../../domain/repositories/app_setting_repository.dart'
    show AppSettingRepository;

part 'app_setting_event.dart';
part 'app_setting_state.dart';

/// Application Facade for App Settings adhering to the Iceberg Pattern:
/// Interacts directly with [AppSettingRepository] without pass-through interactors.
class AppSettingBloc extends BlocSignal<AppSettingEvent, AppSettingState> {
  AppSettingBloc({
    required AppSettingRepository repository,
    CrashReporter? crashReporter,
  })  : _repository = repository,
        _crashReporter = crashReporter,
        super(
          initialState: const AppSettingState(
            themeMode: AppConfig.defaultThemeMode,
            locale: AppConfig.defaultLocale,
            seedColor: Colors.indigo,
          ),
        );

  final AppSettingRepository _repository;
  final CrashReporter? _crashReporter;

  /// Loads saved user settings into state.
  /// Awaited in bootstrap initialization to prevent UI theme flickering.
  Future<void> loadSettings() async {
    try {
      final setting = await _repository.getSettings();
      emit(
        AppSettingState(
          themeMode: setting.themeMode,
          locale: Locale.fromSubtags(languageCode: setting.languageCode),
          seedColor: Color(setting.seedColor),
          hasCompletedOnboarding: setting.hasCompletedOnboarding,
          hasGivenConsent: setting.hasGivenConsent,
          analyticsStorageConsentGranted:
              setting.analyticsStorageConsentGranted,
          adStorageConsentGranted: setting.adStorageConsentGranted,
          adUserDataConsentGranted: setting.adUserDataConsentGranted,
          adPersonalizationSignalsConsentGranted:
              setting.adPersonalizationSignalsConsentGranted,
        ),
      );
    } catch (error, stack) {
      _crashReporter?.recordError(error, stack);
    }
  }

  @override
  FutureOr<void> onEvent(AppSettingEvent event) async {
    super.onEvent(event);

    switch (event) {
      case GetAppSettingEvent():
        loadSettings();
      case AppSettingUpdateThemeModeEvent(themeMode: final themeMode):
        if (stateValue.themeMode == themeMode) return;
        emit(stateValue.copyWith(themeMode: themeMode));
        await _repository.updateThemeMode(themeMode);

      case AppSettingTemporarilyChangeThemeModeEvent(
        themeMode: final themeMode,
      ):
        if (stateValue.themeMode == themeMode) return;
        emit(stateValue.copyWith(themeMode: themeMode));
        await _repository.temporarilyChangeThemeMode(themeMode);

      case AppSettingUpdateLocaleEvent(locale: final locale):
        if (stateValue.locale == locale) return;
        emit(stateValue.copyWith(locale: locale));
        await _repository.updateLocale(locale);

      case AppSettingTemporarilyChangeLocaleEvent(locale: final locale):
        if (stateValue.locale == locale) return;
        emit(stateValue.copyWith(locale: locale));
        await _repository.temporarilyChangeLocale(locale);

      case AppSettingUpdateSeedColorEvent(seedColor: final seedColor):
        if (stateValue.seedColor == seedColor) return;
        emit(stateValue.copyWith(seedColor: seedColor));
        await _repository.updateSeedColor(seedColor);

      case AppSettingTemporarilyChangeSeedColorEvent(
        seedColor: final seedColor,
      ):
        if (stateValue.seedColor == seedColor) return;
        emit(stateValue.copyWith(seedColor: seedColor));
        await _repository.temporarilyChangeSeedColor(seedColor);

      case AppSettingResetToDefaultEvent():
        emit(stateValue.defaultState());
        await _repository.resetToDefaultAppSettings();

      case AppSettingOnboardingEvent(isCompleted: final isCompleted):
        if (stateValue.hasCompletedOnboarding == isCompleted) return;
        emit(stateValue.copyWith(hasCompletedOnboarding: isCompleted));
        await _repository.updateOnboardingCompleted(isCompleted);

      case AppSettingUpdateConsentEvent(
        hasGivenConsent: final hasGivenConsent,
        analyticsStorageConsentGranted: final analyticsStorageConsentGranted,
        adStorageConsentGranted: final adStorageConsentGranted,
        adUserDataConsentGranted: final adUserDataConsentGranted,
        adPersonalizationSignalsConsentGranted: final adPersonalizationSignalsConsentGranted,
        functionalityStorageConsentGranted: final functionalityStorageConsentGranted,
        personalizationStorageConsentGranted: final personalizationStorageConsentGranted,
        securityStorageConsentGranted: final securityStorageConsentGranted,
      ):
        if (stateValue.hasGivenConsent == hasGivenConsent &&
            stateValue.analyticsStorageConsentGranted ==
                analyticsStorageConsentGranted &&
            stateValue.adStorageConsentGranted == adStorageConsentGranted &&
            stateValue.adUserDataConsentGranted == adUserDataConsentGranted &&
            stateValue.adPersonalizationSignalsConsentGranted ==
                adPersonalizationSignalsConsentGranted &&
            stateValue.functionalityStorageConsentGranted ==
                functionalityStorageConsentGranted &&
            stateValue.personalizationStorageConsentGranted ==
                personalizationStorageConsentGranted &&
            stateValue.securityStorageConsentGranted ==
                securityStorageConsentGranted) {
          return;
        }
        emit(
          stateValue.copyWith(
            hasGivenConsent: hasGivenConsent,
            analyticsStorageConsentGranted: analyticsStorageConsentGranted,
            adStorageConsentGranted: adStorageConsentGranted,
            adUserDataConsentGranted: adUserDataConsentGranted,
            adPersonalizationSignalsConsentGranted:
                adPersonalizationSignalsConsentGranted,
            functionalityStorageConsentGranted:
                functionalityStorageConsentGranted,
            personalizationStorageConsentGranted:
                personalizationStorageConsentGranted,
            securityStorageConsentGranted: securityStorageConsentGranted,
          ),
        );
        await _repository.updateConsent(
          hasGivenConsent: hasGivenConsent,
          analyticsStorageConsentGranted: analyticsStorageConsentGranted,
          adStorageConsentGranted: adStorageConsentGranted,
          adUserDataConsentGranted: adUserDataConsentGranted,
          adPersonalizationSignalsConsentGranted:
              adPersonalizationSignalsConsentGranted,
          functionalityStorageConsentGranted:
              functionalityStorageConsentGranted,
          personalizationStorageConsentGranted:
              personalizationStorageConsentGranted,
          securityStorageConsentGranted: securityStorageConsentGranted,
        );
    }
  }
}
