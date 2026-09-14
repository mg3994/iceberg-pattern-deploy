import 'package:blogstore/config/app_config.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;

part 'app_database.g.dart';

class AppSettings extends Table {
  IntColumn get id => integer()();

  // Stores the enum index in SQLite (INTEGER) and maps directly to ThemeMode in Dart
  IntColumn get themeMode => intEnum<ThemeMode>().withDefault(
    Constant(AppConfig.defaultThemeMode.index),
  )();

  TextColumn get languageCode =>
      text().withDefault(Constant(AppConfig.defaultLocale.languageCode))();

  /// Stores ARGB color value as an INTEGER in SQLite
  IntColumn get seedColor => integer().withDefault(
    Constant(AppConfig.defaultThemeSeedColorHex),
  )(); // Colors.indigo.value

  BoolColumn get hasCompletedOnboarding =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get hasGivenConsent =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get analyticsStorageConsentGranted =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get adStorageConsentGranted =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get adUserDataConsentGranted =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get adPersonalizationSignalsConsentGranted =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get functionalityStorageConsentGranted =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get personalizationStorageConsentGranted =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get securityStorageConsentGranted =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedCatalogProducts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get imageUrl => text().nullable()();
  RealColumn get price => real().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get sourceUrl => text()();
  TextColumn get serviceAreasJson => text()();
  DateTimeColumn get publishedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [AppSettings, CachedCatalogProducts])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'blogstore',
              native: const DriftNativeOptions(
                databaseDirectory: getApplicationSupportDirectory,
              ),
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  @override
  int get schemaVersion => 1;

  // Stream<UserSetting> watchSettings() {
  //   return (select(
  //     userSettings,
  //   )..where((t) => t.id.equals(1))).watchSingleOrNull().map(
  //     (setting) =>
  //         setting ??
  //         const UserSetting(
  //           id: 1,
  //           themeMode: ThemeMode.system,
  //           languageCode: 'en',
  //         ),
  //   );
  // }

  // Future<void> updateSettings({
  //   ThemeMode? themeMode,
  //   String? languageCode,
  // }) async {
  //   await into(userSettings).insertOnConflictUpdate(
  //     UserSettingsCompanion(
  //       id: const Value(1),
  //       themeMode: themeMode != null ? Value(themeMode) : const Value.absent(),
  //       languageCode: languageCode != null
  //           ? Value(languageCode)
  //           : const Value.absent(),
  //     ),
  //   );
  // }
}
