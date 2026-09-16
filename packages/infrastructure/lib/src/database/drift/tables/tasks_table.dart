import 'package:drift/drift.dart';

/// Database Table representation of the Tasks schema inside the infrastructure persistence module.
class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get serializedTags => text()();
  DateTimeColumn get createdAt => dateTime()();

  /// 0: synced, 1: pending, 2: error
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
