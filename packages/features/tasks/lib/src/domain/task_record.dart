import 'package:fast_immutable_collections/fast_immutable_collections.dart';

/// Representation of the synchronization state of a task with the cloud.
enum TaskSyncStatus {
  /// Local state matches the remote server truth.
  synced,

  /// Local change has been made but not yet acknowledged by the server.
  pending,

  /// Background synchronization attempt failed.
  error,
}

/// Pure Dart 3 record definition representing a system Task entity.
typedef Task = ({
  String id,
  String title,
  bool isCompleted,
  IList<String> tags,
  DateTime createdAt,
  TaskSyncStatus syncStatus,
  String? lastErrorMessage,
});

/// Structural patch definition carrying partial updates for a Task entity.
typedef TaskPatch = ({
  String? title,
  bool? isCompleted,
  IList<String>? tags,
  bool? isDeleted,
});
