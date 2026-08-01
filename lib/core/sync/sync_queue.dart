import 'dart:async';

import '../monitoring/logger_service.dart';
import 'connectivity_service.dart';

/// Implemented by any offline-first repository that needs to flush pending
/// local changes to the backend. Feature repositories (e.g.
/// `CompositeTaskRepository`) implement this and register themselves with
/// [SyncQueue] on construction — the queue itself stays feature-agnostic.
abstract interface class SyncHandler {
  /// Human-readable name for logging (e.g. `'tasks'`, `'notes'`).
  String get syncHandlerName;

  /// Pushes all locally-pending (`pendingCreate`/`pendingUpdate`/
  /// `pendingDelete`) records for this feature to the backend. Must not
  /// throw — catch internally and leave unresolved records as
  /// `syncFailed` for the next attempt.
  Future<void> syncPendingChanges();
}

/// Coordinates offline-first sync across all registered features.
///
/// Responsibilities:
/// - Watches [ConnectivityService] for the offline → online transition.
/// - On reconnect, asks every registered [SyncHandler] to flush its pending
///   local changes.
/// - Isolates failures per-handler so one feature's sync failure never
///   blocks another's.
///
/// This class intentionally does NOT know about Hive, Firestore, or any
/// specific feature — that keeps it stable as new offline-first features
/// (Tasks, Notes, Flashcards, Study History, Planner) are added in later
/// phases; they just call [register].
class SyncQueue {
  SyncQueue({
    required ConnectivityService connectivityService,
    required LoggerService logger,
  })  : _connectivityService = connectivityService,
        _logger = logger {
    _subscription = _connectivityService.onStatusChange.listen(_onConnectivityChanged);
  }

  final ConnectivityService _connectivityService;
  final LoggerService _logger;
  final List<SyncHandler> _handlers = [];
  StreamSubscription<bool>? _subscription;
  bool _wasOffline = false;
  bool _isSyncing = false;

  void register(SyncHandler handler) {
    _handlers.add(handler);
    _logger.debug('[sync] registered handler', handler.syncHandlerName);
  }

  void unregister(SyncHandler handler) => _handlers.remove(handler);

  /// Triggers a sync pass immediately, regardless of the last known
  /// connectivity transition. Safe to call from a manual "retry" action.
  Future<void> syncNow() => _flushAll();

  Future<void> _onConnectivityChanged(bool isOnline) async {
    if (!isOnline) {
      _wasOffline = true;
      return;
    }
    if (_wasOffline) {
      _wasOffline = false;
      await _flushAll();
    }
  }

  Future<void> _flushAll() async {
    if (_isSyncing || _handlers.isEmpty) return;
    _isSyncing = true;
    _logger.info('[sync] flushing ${_handlers.length} handler(s)');

    for (final handler in List<SyncHandler>.of(_handlers)) {
      try {
        await handler.syncPendingChanges();
      } catch (e, stackTrace) {
        _logger.error('[sync] handler failed: ${handler.syncHandlerName}', error: e, stackTrace: stackTrace);
      }
    }

    _isSyncing = false;
  }

  void dispose() {
    _subscription?.cancel();
    _handlers.clear();
  }
}
