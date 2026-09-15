/// Shared taxonomy for synchronization exceptions across the workspace.
class SyncRollbackException implements Exception {
  final String message;
  final Object? cause;

 const SyncRollbackException(this.message, [this.cause]);

  @override
  String toString() => 'SyncRollbackException: $message';
}
