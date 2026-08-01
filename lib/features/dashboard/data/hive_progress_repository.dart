import 'package:hive/hive.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../../../core/monitoring/logger_service.dart';
import '../domain/models/activity_entry.dart';
import '../domain/models/activity_type.dart';
import '../domain/models/user_progress.dart';
import '../domain/repositories/progress_repository.dart';

/// Hive-backed [ProgressRepository]. Holds the streak/XP business rules
/// described in the interface doc — this is the only place that decides
/// "does this completion extend the streak, and by how much".
class HiveProgressRepository implements ProgressRepository {
  HiveProgressRepository({
    required Box<UserProgress> progressBox,
    required Box<ActivityEntry> activityBox,
    required LoggerService logger,
  })  : _progressBox = progressBox,
        _activityBox = activityBox,
        _logger = logger;

  static const String _progressKey = 'main';

  /// Hard cap on stored activity entries so the box can't grow forever on
  /// a long-lived install; oldest entries are trimmed on write.
  static const int _maxActivityEntries = 200;

  final Box<UserProgress> _progressBox;
  final Box<ActivityEntry> _activityBox;
  final LoggerService _logger;

  UserProgress get _current => _progressBox.get(_progressKey) ?? const UserProgress();

  @override
  Stream<UserProgress> watchProgress() async* {
    yield _current;
    yield* _progressBox.watch(key: _progressKey).map((_) => _current);
  }

  @override
  Future<Result<UserProgress>> getProgress() async {
    try {
      return Success(_current);
    } catch (e, stackTrace) {
      _logger.error('[progress] getProgress failed', error: e, stackTrace: stackTrace);
      return const ResultError(CacheFailure('Could not load your progress.'));
    }
  }

  @override
  Future<Result<UserProgress>> recordTaskCompleted({
    required String taskTitle,
    required int xp,
  }) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final progress = _current;

      final newStreak = _nextStreak(lastActiveDate: progress.lastActiveDate, today: today, currentStreak: progress.currentStreak);

      final updated = progress.copyWith(
        totalXp: progress.totalXp + xp,
        currentStreak: newStreak,
        bestStreak: newStreak > progress.bestStreak ? newStreak : progress.bestStreak,
        lastActiveDate: today,
      );

      await _progressBox.put(_progressKey, updated);
      await _appendActivity(
        ActivityEntry(
          type: ActivityType.taskCompleted,
          title: 'Completed "$taskTitle"',
          timestamp: now,
          xpDelta: xp,
        ),
      );

      return Success(updated);
    } catch (e, stackTrace) {
      _logger.error('[progress] recordTaskCompleted failed', error: e, stackTrace: stackTrace);
      return const ResultError(CacheFailure('Could not update your progress.'));
    }
  }

  @override
  Future<Result<UserProgress>> revertTaskCompletion({required int xp}) async {
    try {
      final progress = _current;
      final updated = progress.copyWith(totalXp: (progress.totalXp - xp).clamp(0, 1 << 31));
      await _progressBox.put(_progressKey, updated);
      return Success(updated);
    } catch (e, stackTrace) {
      _logger.error('[progress] revertTaskCompletion failed', error: e, stackTrace: stackTrace);
      return const ResultError(CacheFailure('Could not update your progress.'));
    }
  }

  @override
  Future<Result<void>> recordTaskCreated({required String taskTitle}) async {
    try {
      await _appendActivity(
        ActivityEntry(
          type: ActivityType.taskCreated,
          title: 'Added "$taskTitle"',
          timestamp: DateTime.now(),
        ),
      );
      return const Success(null);
    } catch (e, stackTrace) {
      _logger.error('[progress] recordTaskCreated failed', error: e, stackTrace: stackTrace);
      return const ResultError(CacheFailure('Could not log that activity.'));
    }
  }

  @override
  Stream<List<ActivityEntry>> watchRecentActivity({int limit = 20}) async* {
    yield _recentActivity(limit);
    yield* _activityBox.watch().map((_) => _recentActivity(limit));
  }

  List<ActivityEntry> _recentActivity(int limit) {
    final entries = _activityBox.values.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries.take(limit).toList();
  }

  Future<void> _appendActivity(ActivityEntry entry) async {
    await _activityBox.add(entry);
    if (_activityBox.length > _maxActivityEntries) {
      final sortedKeys = _activityBox.keys.toList()
        ..sort((a, b) {
          final ta = _activityBox.get(a)?.timestamp ?? DateTime(0);
          final tb = _activityBox.get(b)?.timestamp ?? DateTime(0);
          return ta.compareTo(tb);
        });
      final toRemove = sortedKeys.take(_activityBox.length - _maxActivityEntries);
      await _activityBox.deleteAll(toRemove);
    }
  }

  /// Streak rule: same calendar day as last activity → unchanged; exactly
  /// the next calendar day → +1; any bigger gap (or first-ever activity)
  /// → resets to 1.
  int _nextStreak({required DateTime? lastActiveDate, required DateTime today, required int currentStreak}) {
    if (lastActiveDate == null) return 1;
    if (lastActiveDate == today) return currentStreak == 0 ? 1 : currentStreak;
    final yesterday = today.subtract(const Duration(days: 1));
    if (lastActiveDate == yesterday) return currentStreak + 1;
    return 1;
  }
}
