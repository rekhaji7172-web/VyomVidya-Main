import 'package:hive/hive.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../../../core/monitoring/logger_service.dart';
import '../../../core/sync/sync_queue.dart';
import '../domain/models/task.dart';
import '../domain/repositories/task_repository.dart';

/// Offline-first [TaskRepository] backed entirely by a local Hive [Box].
///
/// There is no remote backend yet (Firebase is out of scope for this
/// phase per the Phase 2 brief), so Hive is the single source of truth —
/// every [Task] is created with `syncStatus: SyncStatus.synced` by
/// default, which is accurate today (there is nothing to be "out of sync"
/// with). [syncPendingChanges] is intentionally a no-op for the same
/// reason; it still implements [SyncHandler] and is registered with the
/// app's [SyncQueue] so that once a `FirestoreTaskRepository` lands, this
/// class (or a `CompositeTaskRepository` wrapping it) starts participating
/// in real sync with zero changes to `presentation/`.
class HiveTaskRepository implements TaskRepository, SyncHandler {
  HiveTaskRepository({required Box<Task> box, required LoggerService logger})
      : _box = box,
        _logger = logger;

  final Box<Task> _box;
  final LoggerService _logger;

  @override
  String get syncHandlerName => 'tasks';

  @override
  Future<Result<List<Task>>> getAll() async {
    try {
      return Success(_sortedTasks());
    } catch (e, stackTrace) {
      _logger.error('[tasks] getAll failed', error: e, stackTrace: stackTrace);
      return const ResultError(CacheFailure('Could not load your tasks.'));
    }
  }

  @override
  Future<Result<Task>> getById(String localId) async {
    final task = _box.get(localId);
    if (task == null) {
      return const ResultError(CacheFailure('Task not found.'));
    }
    return Success(task);
  }

  @override
  Future<Result<Task>> create(Task task) async {
    try {
      await _box.put(task.localId, task);
      return Success(task);
    } catch (e, stackTrace) {
      _logger.error('[tasks] create failed', error: e, stackTrace: stackTrace);
      return const ResultError(CacheFailure('Could not save your task.'));
    }
  }

  @override
  Future<Result<Task>> update(Task task) async {
    try {
      await _box.put(task.localId, task);
      return Success(task);
    } catch (e, stackTrace) {
      _logger.error('[tasks] update failed', error: e, stackTrace: stackTrace);
      return const ResultError(CacheFailure('Could not update your task.'));
    }
  }

  @override
  Future<Result<void>> delete(String localId) async {
    try {
      await _box.delete(localId);
      return const Success(null);
    } catch (e, stackTrace) {
      _logger.error('[tasks] delete failed', error: e, stackTrace: stackTrace);
      return const ResultError(CacheFailure('Could not delete your task.'));
    }
  }

  @override
  Stream<List<Task>> watchAll() async* {
    yield _sortedTasks();
    yield* _box.watch().map((_) => _sortedTasks());
  }

  @override
  Future<void> syncPendingChanges() async {
    // No remote backend yet — see class doc. Left as an explicit no-op
    // (rather than omitted) so the SyncHandler contract stays visibly
    // satisfied and this is the single place to implement the real push
    // once FirestoreTaskRepository exists.
  }

  List<Task> _sortedTasks() {
    final tasks = _box.values.toList();
    tasks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return tasks;
  }
}
