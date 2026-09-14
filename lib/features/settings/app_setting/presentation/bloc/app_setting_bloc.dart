import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:material_ui/material_ui.dart'
    show Color, Colors, Locale, ThemeMode;

import '../../../../../config/app_config.dart' show AppConfig;
import '../../../../../core/monitoring/crash_reporter.dart' show CrashReporter;
import '../../domain/usecases/get_app_settings.dart';
import '../../domain/usecases/reset_app_settings.dart'
    show ResetAppSettingsUseCase;
import '../../domain/usecases/temp_change_locale.dart';
import '../../domain/usecases/temp_change_seed_color.dart';
import '../../domain/usecases/temp_change_theme_mode.dart';
import '../../domain/usecases/update_consent.dart' show UpdateConsentUseCase;
import '../../domain/usecases/update_locale.dart';
import '../../domain/usecases/update_onboarding_completed.dart'
    show UpdateOnboardingCompletedUseCase;
import '../../domain/usecases/update_seed_color.dart';
import '../../domain/usecases/update_theme_mode.dart';

part 'app_setting_event.dart';
part 'app_setting_state.dart';

class AppSettingBloc extends BlocSignal<AppSettingEvent, AppSettingState> {
  AppSettingBloc({
    required this._getAppSettings,
    required this._resetAppSettings,
    required this._updateThemeMode,
    required this._updateLocale,
    required this._updateSeedColor,
    required this._updateOnboardingCompleted,
    required this._updateConsent,
    required this._tempChangeThemeMode,
    required this._tempChangeLocale,
    required this._tempChangeSeedColor,
    this._crashReporter,
  }) : super(
         initialState: const AppSettingState(
           themeMode: AppConfig.defaultThemeMode,
           locale: AppConfig.defaultLocale,
           seedColor: Colors.indigo,
         ),
       );

  final GetAppSettingsUseCase _getAppSettings;
  final ResetAppSettingsUseCase _resetAppSettings;
  final UpdateThemeModeUseCase _updateThemeMode;
  final UpdateLocaleUseCase _updateLocale;
  final UpdateSeedColorUseCase _updateSeedColor;
  final UpdateOnboardingCompletedUseCase _updateOnboardingCompleted;
  final UpdateConsentUseCase _updateConsent;
  final CrashReporter? _crashReporter;
  //
  final TemporarilyChangeThemeModeUseCase _tempChangeThemeMode;
  final TemporarilyChangeLocaleUseCase _tempChangeLocale;
  final TemporarilyChangeSeedColorUseCase _tempChangeSeedColor;

  /// Loads saved user settings into state.
  /// Awaited in bootstrap initialization to prevent UI theme flickering.
  Future<void> loadSettings() async {
    try {
      final setting = await _getAppSettings();
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
        await _updateThemeMode(themeMode);
      case AppSettingTemporarilyChangeThemeModeEvent(
        themeMode: final themeMode,
      ):
        if (stateValue.themeMode == themeMode) return;
        emit(stateValue.copyWith(themeMode: themeMode));
        await _tempChangeThemeMode(themeMode);
      case AppSettingUpdateLocaleEvent(locale: final locale):
        if (stateValue.locale == locale) return;
        emit(stateValue.copyWith(locale: locale));
        await _updateLocale(locale);

      case AppSettingTemporarilyChangeLocaleEvent(locale: final locale):
        if (stateValue.locale == locale) return;
        emit(stateValue.copyWith(locale: locale));
        await _tempChangeLocale(locale);

      case AppSettingUpdateSeedColorEvent(seedColor: final seedColor):
        if (stateValue.seedColor == seedColor) return;
        emit(stateValue.copyWith(seedColor: seedColor));
        await _updateSeedColor(seedColor);

      case AppSettingTemporarilyChangeSeedColorEvent(
        seedColor: final seedColor,
      ):
        if (stateValue.seedColor == seedColor) return;
        emit(stateValue.copyWith(seedColor: seedColor));
        await _tempChangeSeedColor(
          seedColor,
        ); // all those _temp_ are just for analytics
      case AppSettingResetToDefaultEvent():
        emit(stateValue.defaultState());
        await _resetAppSettings();

      case AppSettingOnboardingEvent(isCompleted: final isCompleted):
        if (stateValue.hasCompletedOnboarding == isCompleted) return;
        emit(stateValue.copyWith(hasCompletedOnboarding: isCompleted));
        await _updateOnboardingCompleted(isCompleted);

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
        await _updateConsent(
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
