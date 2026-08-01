import '../error/result.dart';

/// Generic CRUD contract that every feature's domain repository interface
/// should follow (e.g. `TaskRepository extends BaseRepository<Task>`).
///
/// This is the backbone of the dependency-inversion rule: `domain/` only
/// ever depends on interfaces like this one. Concrete `data/` classes
/// (`FirestoreTaskRepository`, `HiveTaskRepository`,
/// `CompositeTaskRepository`) implement it, and Riverpod providers expose
/// the interface type — never the concrete class — so the backend can be
/// swapped without touching `domain/` or `presentation/`.
///
/// Offline-first features additionally implement `SyncHandler`
/// (`core/sync/sync_queue.dart`) on their `Composite*Repository` so pending
/// local changes flush automatically on reconnect.
abstract interface class BaseRepository<T> {
  Future<Result<List<T>>> getAll();

  Future<Result<T>> getById(String id);

  Future<Result<T>> create(T item);

  Future<Result<T>> update(T item);

  Future<Result<void>> delete(String id);

  /// Real-time stream of the collection, where the backend supports it
  /// (Firestore snapshots, Hive box watch). Implementations backed by a
  /// one-shot API can emit a single value and close.
  Stream<List<T>> watchAll();
}
