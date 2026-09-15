import 'package:drift/drift.dart';

/// Database Table representation of the Tasks schema inside the infrastructure persistence module.
class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get serializedTags => text()();

  @override
  Set<Column> get primaryKey => {id};
}
