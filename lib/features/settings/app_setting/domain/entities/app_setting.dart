
export '../../../../../infrastructure/database/drift/app_database.dart'
    show AppSetting;

// class AppSetting {
//   const AppSetting({
//     required this.themeMode,
//     required this.locale,
//     required this.seedColor,
//   });

//   final ThemeMode themeMode;
//   final Locale locale;
//   final Color seedColor;

//   AppSetting copyWith({
//     ThemeMode? themeMode,
//     Locale? locale,
//     Color? seedColor,
//   }) {
//     return AppSetting(
//       themeMode: themeMode ?? this.themeMode,
//       locale: locale ?? this.locale,
//       seedColor: seedColor ?? this.seedColor,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is AppSetting &&
//         other.themeMode == themeMode &&
//         other.locale == locale &&
//         other.seedColor == seedColor;
//   }

//   @override
//   int get hashCode => Object.hash(themeMode, locale, seedColor);
// }
