// // ==========================================
// // 3. SETTINGS STATE (settings_state.dart)
// // ==========================================
// part of 'settings_bloc.dart';

//  class SettingsState {
//   final ThemeMode themeMode;
//   final Locale locale;
//   final Color seedColor;

//   const SettingsState({
//     required this.themeMode,
//     required this.locale,
//     required this.seedColor,
//   });

//   SettingsState copyWith({
//     ThemeMode? themeMode,
//     Locale? locale,
//     Color? seedColor,
//   }) {
//     return SettingsState(
//       themeMode: themeMode ?? this.themeMode,
//       locale: locale ?? this.locale,
//       seedColor: seedColor ?? this.seedColor,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is SettingsState &&
//         other.themeMode == themeMode &&
//         other.locale == locale &&
//         other.seedColor == seedColor;
//   }

//   @override
//   int get hashCode => Object.hash(themeMode, locale, seedColor);
// }
