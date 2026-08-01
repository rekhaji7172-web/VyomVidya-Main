/// Sync state of a locally-stored record. Every offline-first model
/// (Tasks, Notes, Flashcards, Study History, Planner) carries one of these
/// so the UI and [SyncQueue] know what still needs to reach the backend.
enum SyncStatus {
  /// Matches the remote backend — nothing to do.
  synced,

  /// Created locally, not yet pushed.
  pendingCreate,

  /// Modified locally, not yet pushed.
  pendingUpdate,

  /// Deleted locally, tombstone not yet pushed.
  pendingDelete,

  /// Last push attempt failed (e.g. server rejected it); needs manual
  /// or backoff retry rather than being silently retried forever.
  syncFailed,
}
