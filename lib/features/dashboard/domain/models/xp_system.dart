import '../../../../core/widgets/league_badge.dart';

/// Single source of truth for XP → level → league math. [UserProgress]
/// only ever stores the raw cumulative `xp` int; everything else
/// (level, progress-within-level, league) is derived here so there's never
/// a stale/inconsistent stored level.
///
/// Curve: level *n* requires `100 + (n-1) * 50` XP beyond the previous
/// level (linear ramp — level 1→2 needs 100 XP, level 2→3 needs 150, etc).
/// This is a first pass; tune freely later, nothing else depends on the
/// specific numbers.
abstract final class XpSystem {
  static int xpRequiredForLevel(int level) => 100 + (level - 1) * 50;

  static int levelForTotalXp(int totalXp) {
    var level = 1;
    var remaining = totalXp;
    while (remaining >= xpRequiredForLevel(level)) {
      remaining -= xpRequiredForLevel(level);
      level++;
    }
    return level;
  }

  /// XP earned within the current level (i.e. progress toward the next one).
  static int xpIntoCurrentLevel(int totalXp) {
    var level = 1;
    var remaining = totalXp;
    while (remaining >= xpRequiredForLevel(level)) {
      remaining -= xpRequiredForLevel(level);
      level++;
    }
    return remaining;
  }

  static double progressToNextLevel(int totalXp) {
    final level = levelForTotalXp(totalXp);
    final into = xpIntoCurrentLevel(totalXp);
    return into / xpRequiredForLevel(level);
  }

  static League leagueForLevel(int level) {
    if (level >= 31) return League.mythic;
    if (level >= 26) return League.master;
    if (level >= 21) return League.diamond;
    if (level >= 16) return League.platinum;
    if (level >= 11) return League.gold;
    if (level >= 6) return League.silver;
    return League.bronze;
  }
}
