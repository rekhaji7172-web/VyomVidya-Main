/// Base type for all recoverable, user-facing failures across the app.
///
/// Repositories and services return `Result<T>` (see `result.dart`) instead
/// of throwing, and wrap unexpected errors into one of these subtypes so the
/// presentation layer can react consistently (show retry, show offline
/// banner, etc.) without knowing about Firebase/Hive/HTTP specifics.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

/// No network connection and no usable local cache.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// Remote backend rejected the request or returned an error
/// (Firestore, future REST backend, etc. all map into this).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on our end.']);
}

/// Local cache (Hive) read/write failure.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not read local data.']);
}

/// Input failed validation before reaching a repository.
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Please check your input.']);
}

/// User is not authenticated / session expired.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Please sign in again.']);
}

/// Catch-all for anything not classified above.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
