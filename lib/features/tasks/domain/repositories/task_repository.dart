import '../../../../core/error/result.dart';
import '../models/task.dart';

/// Domain-layer contract for task persistence. `presentation/` depends
/// only on this interface — never on `HiveTaskRepository` directly — so a
/// future `FirestoreTaskRepository` / `CompositeTaskRepository` can be
/// swapped in (per the dependency-inversion rule) without touching any
/// screen or provider signature.
abstract interface class TaskRepository {
  Future<Result<List<Task>>> getAll();

  Future<Result<Task>> getById(String localId);

  Future<Result<Task>> create(Task task);

  Future<Result<Task>> update(Task task);

  Future<Result<void>> delete(String localId);

  /// Live stream of every task, sorted by [Task.updatedAt] descending.
  /// The presentation layer derives all filtered views (today/upcoming/
  /// completed/overdue/search/sort) from this single stream.
  Stream<List<Task>> watchAll();
}
