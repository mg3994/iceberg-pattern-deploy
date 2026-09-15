import 'package:drift/drift.dart';

/// Database Table representation of the Tasks schema isolated within the feature module.
class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get serializedTags => text()(); // Comma-separated list for DRY storage format

  @override
  Set<Column> get primaryKey => {id};
}
