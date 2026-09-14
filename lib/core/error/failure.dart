sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'A network error occurred.']);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'The server returned an error.']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local data could not be read.']);
}

final class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Authentication failed.']);
}
