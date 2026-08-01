import 'sync_status.dart';

/// Contract for any domain model that participates in offline-first sync
/// (Tasks, Notes, Flashcards, Planner entries, Study History entries).
///
/// Concrete models (defined with `freezed` in each feature's `domain/models`
/// once built) implement this so [SyncQueue] and repository base classes
/// can operate generically over "anything syncable" without knowing about
/// Task/Note/Flashcard specifically.
abstract interface class Syncable {
  /// Local-only identity, stable across renames/edits (Hive key / UUID).
  String get localId;

  /// Remote document id once pushed; null until the first successful sync.
  String? get remoteId;

  SyncStatus get syncStatus;

  /// Last local modification time — used for last-write-wins conflict
  /// resolution against the server's `updatedAt`.
  DateTime get updatedAt;
}
