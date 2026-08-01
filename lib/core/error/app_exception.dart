/// Thrown for truly exceptional, non-recoverable programmer errors
/// (misconfiguration, invariant violations). This is distinct from
/// [Failure]: `Failure` values are expected, user-facing outcomes returned
/// via `Result`; `AppException` should be rare and is caught at the
/// top of the widget tree (see `ErrorBoundary` usage in `app.dart`) and
/// reported via `CrashReportingService`.
class AppException implements Exception {
  const AppException(this.message, {this.cause, this.stackTrace});

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException: $message${cause != null ? ' (cause: $cause)' : ''}';
}
