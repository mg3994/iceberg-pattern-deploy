import 'package:drift/drift.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import '../../domain/task_record.dart';
import '../task_data_source.dart';

/// Production Relational Storage implementation mapping low-level Drift transactions to core entities.
class LocalTaskDataSource implements TaskDataSource {
  final GeneratedDatabase _db;
  final ResultSetImplementation _table;

  LocalTaskDataSource({
    required GeneratedDatabase database,
    required ResultSetImplementation table,
  })  : _db = database,
        _table = table;

  @override
  Stream<List<Task>> get taskStream {
    final selectStatement = _db.select(_table);
    return selectStatement.watch().map((rows) {
      return rows.map((row) {
        // Read low-level properties dynamically out of the modular schema mapper
        final map = row.toColumns(false);
        final id = map['tasks_table.id']?.evaluate(null) as String? ?? '';
        final title = map['tasks_table.title']?.evaluate(null) as String? ?? '';
        final isCompleted = map['tasks_table.is_completed']?.evaluate(null) as bool? ?? false;
        final rawTags = map['tasks_table.serialized_tags']?.evaluate(null) as String? ?? '';

        final tagsList = rawTags.isEmpty
            ? const IListConst<String>([])
            : IList<String>(rawTags.split(','));

        return (
          id: id,
          title: title,
          isCompleted: isCompleted,
          tags: tagsList,
        );
      }).toList();
    });
  }

  @override
  Future<void> updateTask(String id, bool isCompleted) async {
    final updateStatement = _db.update(_table)..where((t) {
      final idColumn = _table.columnsByName['id'] as Expression<String>;
      return idColumn.equals(id);
    });

    // Create a dynamic insert companion parameter dictionary mapping
    await updateStatement.write(RawValuesInsertable({
      'is_completed': Variable<bool>(isCompleted),
    }));
  }

  @override
  Future<void> deleteTask(String id) async {
    final deleteStatement = _db.delete(_table)..where((t) {
      final idColumn = _table.columnsByName['id'] as Expression<String>;
      return idColumn.equals(id);
    });

    await deleteStatement.go();
  }
}
