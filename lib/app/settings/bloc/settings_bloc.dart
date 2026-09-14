// // ==========================================
// // 1. SETTINGS BLOC (settings_bloc.dart)
// // ==========================================
// import 'dart:async';

// import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
// import 'package:material_ui/material_ui.dart'
//     show Color, Colors, Locale, ThemeMode;

// import '../../../config/app_config.dart' show AppConfig;
// import '../../../injection/dependency_injection.dart' show Dependencies;
// import '../../helpers/extensions.dart' show AppDatabaseSettings;

// part 'settings_event.dart';
// part 'settings_state.dart';

// class SettingsBloc extends BlocSignal<SettingsEvent, SettingsState> {
//   SettingsBloc(this._dependencies)
//     : super(
//         initialState: const SettingsState(
//           themeMode: AppConfig.defaultThemeMode,
//           locale: AppConfig.defaultLocale,
//           seedColor: Colors.indigo,
//         ),
//       );

//   final Dependencies _dependencies;

//   /// Loads saved user settings from the database into state.
//   /// Awaited in bootstrap initialization to prevent UI theme flickering.
//   Future<void> loadSettings() async {
//     try {
//       final setting = await _dependencies.database.loadSettings();

//       emit(
//         SettingsState(
//           themeMode: setting.themeMode,
//           locale: Locale(setting.languageCode),
//           seedColor: Color(setting.seedColor),
//         ),
//       );
//     } catch (error, stack) {
//       _dependencies.crashReporter.recordError(error, stack);
//     }
//   }

//   @override
//   FutureOr<void> onEvent(SettingsEvent event) async {
//     super.onEvent(event);

//     final db = _dependencies.database;
//     final analytics = _dependencies.analyticsGateway;

//     switch (event) {
//       case SettingsUpdateThemeModeEvent(themeMode: final themeMode):
//         if (stateValue.themeMode == themeMode) return;
//         emit(stateValue.copyWith(themeMode: themeMode));
//         await db.updateSettings(themeMode: themeMode);
//         await analytics.logEvent(
//           'theme_changed',
//           parameters: {'theme_mode': themeMode.name},
//         );

//       case SettingsUpdateLocaleEvent(locale: final locale):
//         if (stateValue.locale == locale) return;
//         emit(stateValue.copyWith(locale: locale));
//         await db.updateSettings(languageCode: locale.languageCode);
//         await analytics.logEvent(
//           'locale_changed',
//           parameters: {'language_code': locale.languageCode},
//         );

//       case SettingsUpdateSeedColorEvent(seedColor: final seedColor):
//         if (stateValue.seedColor == seedColor) return;
//         emit(stateValue.copyWith(seedColor: seedColor));
//         await db.updateSettings(seedColor: seedColor);
//         await analytics.logEvent(
//           'seed_color_changed',
//           parameters: {'seed_color': seedColor.value.toRadixString(16)},
//         );
//     }
//   }
// }
