import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/di/service_providers.dart';
import '../../../../core/widgets/league_badge.dart';
import '../../../tasks/presentation/providers/task_providers.dart';
import '../../data/hive_progress_repository.dart';
import '../../domain/models/activity_entry.dart';
import '../../domain/models/user_progress.dart';
import '../../domain/models/xp_system.dart';
import '../../domain/repositories/progress_repository.dart';

/// Must be overridden in `app_bootstrap.dart` with the opened boxes before
/// `runApp` — same guard pattern as `sharedPreferencesProvider`.
final userProgressBoxProvider = Provider<Box<UserProgress>>(
  (ref) => throw UnimplementedError('userProgressBoxProvider must be overridden in app_bootstrap.dart'),
);

final activityLogBoxProvider = Provider<Box<ActivityEntry>>(
  (ref) => throw UnimplementedError('activityLogBoxProvider must be overridden in app_bootstrap.dart'),
);

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return HiveProgressRepository(
    progressBox: ref.watch(userProgressBoxProvider),
    activityBox: ref.watch(activityLogBoxProvider),
    logger: ref.watch(loggerServiceProvider),
  );
});

final userProgressProvider = StreamProvider<UserProgress>((ref) {
  return ref.watch(progressRepositoryProvider).watchProgress();
});

final recentActivityProvider = StreamProvider<List<ActivityEntry>>((ref) {
  return ref.watch(progressRepositoryProvider).watchRecentActivity();
});

/// Derived, read-only view of [UserProgress] for the XP Summary card —
/// keeps level/progress/league math (from [XpSystem]) out of widget code.
class XpDisplay {
  const XpDisplay({
    required this.totalXp,
    required this.level,
    required this.xpIntoLevel,
    required this.xpForNextLevel,
    required this.progress,
    required this.league,
  });

  final int totalXp;
  final int level;
  final int xpIntoLevel;
  final int xpForNextLevel;
  final double progress;
  final League league;
}

final xpDisplayProvider = Provider<XpDisplay>((ref) {
  final totalXp = ref.watch(userProgressProvider).value?.totalXp ?? 0;
  final level = XpSystem.levelForTotalXp(totalXp);
  return XpDisplay(
    totalXp: totalXp,
    level: level,
    xpIntoLevel: XpSystem.xpIntoCurrentLevel(totalXp),
    xpForNextLevel: XpSystem.xpRequiredForLevel(level),
    progress: XpSystem.progressToNextLevel(totalXp),
    league: XpSystem.leagueForLevel(level),
  );
});

/// Aggregated stats for the Dashboard's "Today's Focus" card. Focus-time
/// minutes will start reflecting real data once the Pomodoro/Timer feature
/// (Phase 3+) starts writing sessions; it's accurately `0` until then —
/// not a placeholder, just a true "no sessions logged yet" value.
class TodaysFocusStats {
  const TodaysFocusStats({
    required this.totalTasksToday,
    required this.completedTasksToday,
    required this.focusMinutesToday,
    required this.xpEarnedToday,
  });

  final int totalTasksToday;
  final int completedTasksToday;
  final int focusMinutesToday;
  final int xpEarnedToday;
}

final todaysFocusStatsProvider = Provider<TodaysFocusStats>((ref) {
  final todayTasks = ref.watch(todayTasksProvider);
  final activity = ref.watch(recentActivityProvider).value ?? const <ActivityEntry>[];

  final now = DateTime.now();
  final xpToday = activity
      .where((a) => a.timestamp.year == now.year && a.timestamp.month == now.month && a.timestamp.day == now.day)
      .fold<int>(0, (sum, a) => sum + a.xpDelta);

  return TodaysFocusStats(
    totalTasksToday: todayTasks.length,
    completedTasksToday: todayTasks.where((t) => t.isCompleted).length,
    focusMinutesToday: 0, // no Pomodoro/Timer feature yet — see class doc
    xpEarnedToday: xpToday,
  );
});
