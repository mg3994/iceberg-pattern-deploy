// import 'package:domain/domain.dart';
// ignore: depend_on_referenced_packages
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/tasks_table.dart';

import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;

part 'app_database.g.dart';

// TODO: below code to separate related package

class AppearanceSettings extends Table {
  IntColumn get id => integer()();
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

// TODO: remove above from here to separate related package

@DriftDatabase(tables: [AppearanceSettings, TasksTable])
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
}
