import '../../../../core/error/result.dart';
import '../models/activity_entry.dart';
import '../models/user_progress.dart';

/// Domain-layer contract for XP, streak, and activity-feed persistence.
/// Keeping streak/XP bookkeeping behind these two composite methods
/// (rather than exposing raw `setXp`/`setStreak` setters) means the
/// *rules* for "what happens when a task completes" live in exactly one
/// place (the repository implementation), not scattered across UI code.
abstract interface class ProgressRepository {
  Stream<UserProgress> watchProgress();

  Future<Result<UserProgress>> getProgress();

  /// Applies the effects of completing a task: adds [xp] to the total,
  /// advances the daily streak (if this is the first completion today),
  /// and appends a [ActivityEntry.taskCompleted] entry to the feed.
  Future<Result<UserProgress>> recordTaskCompleted({required String taskTitle, required int xp});

  /// Reverses [recordTaskCompleted] when a task is un-checked — subtracts
  /// [xp] back out. Streak is intentionally left untouched (once a day
  /// counts, un-checking one of several completions that day shouldn't
  /// retroactively break it).
  Future<Result<UserProgress>> revertTaskCompletion({required int xp});

  /// Appends a [ActivityEntry.taskCreated] entry (no XP/streak effect).
  Future<Result<void>> recordTaskCreated({required String taskTitle});

  Stream<List<ActivityEntry>> watchRecentActivity({int limit = 20});
}
