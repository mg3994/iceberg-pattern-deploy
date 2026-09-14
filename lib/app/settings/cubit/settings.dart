// import 'package:bloc_signals_flutter/bloc_signals_flutter.dart'
//     show CubitSignal;
// import 'package:material_ui/material_ui.dart' show ThemeMode, Locale;

// import '../../../config/app_config.dart' show AppConfig;
// import '../../../infrastructure/database/drift/app_database.dart'
//     show AppDatabase;
// import '../../helpers/extensions.dart' show AppDatabaseSettings;

// class SettingsState {
//   final ThemeMode themeMode;
//   final Locale locale;

//   const SettingsState({required this.themeMode, required this.locale});
// }

// class SettingsCubit extends CubitSignal<SettingsState> {
//   SettingsCubit(this._db)
//     : super(
//         initialState: const SettingsState(
//           themeMode: AppConfig.defaultThemeMode,
//           locale: AppConfig.defaultLocale,
//         ),
//       );

//   final AppDatabase _db;

//   /// Asynchronously loads settings without blocking app launch
//   Future<void> loadSettings() async {
//     final setting = await (_db.select(
//       _db.userSettings,
//     )..where((t) => t.id.equals(1))).getSingleOrNull();

//     if (setting != null) {
//       emit(
//         SettingsState(
//           themeMode: setting.themeMode,
//           locale: Locale(setting.languageCode),
//         ),
//       );
//     }
//   }

//   Future<void> updateTheme(ThemeMode mode) async {
//     emit(SettingsState(themeMode: mode, locale: stateValue.locale));
//     await _db.updateSettings(themeMode: mode);
//   }

//   Future<void> updateLocale(Locale locale) async {
//     emit(SettingsState(themeMode: stateValue.themeMode, locale: locale));
//     await _db.updateSettings(languageCode: locale.languageCode);
//   }
// }
