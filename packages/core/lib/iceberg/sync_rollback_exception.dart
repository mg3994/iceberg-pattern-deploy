/// Exception thrown when an optimistic mutation fails and state is rolled back.
class SyncRollbackException implements Exception {
  const SyncRollbackException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() =>
      cause != null ? 'SyncRollbackException: $message ($cause)' : 'SyncRollbackException: $message';
}
