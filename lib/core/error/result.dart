import 'failure.dart';

/// A `Result<T>` is either [Success] with a value, or [ResultError] with a
/// [Failure]. All repository interfaces return `Future<Result<T>>` instead
/// of throwing — this keeps error handling explicit and makes the
/// presentation layer exhaustive-switch safe (Dart 3 sealed classes).
///
/// Example:
/// ```dart
/// final result = await taskRepository.getTasks();
/// switch (result) {
///   case Success(:final value) => showTasks(value),
///   case ResultError(:final failure) => showError(failure.message),
/// }
/// ```
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isError => this is ResultError<T>;

  /// Returns the success value or `null` if this is an error.
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        ResultError<T>() => null,
      };

  /// Maps a successful value to a new type, passing errors through unchanged.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Success<T>(:final value) => Success<R>(transform(value)),
        ResultError<T>(:final failure) => ResultError<R>(failure),
      };
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class ResultError<T> extends Result<T> {
  const ResultError(this.failure);

  final Failure failure;
}
