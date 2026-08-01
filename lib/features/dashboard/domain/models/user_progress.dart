import 'package:flutter/foundation.dart';

@immutable
class UserProgress {
  const UserProgress({
    this.totalXp = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastActiveDate,
  });

  final int totalXp;
  final int currentStreak;
  final int bestStreak;

  /// Calendar date (midnight-normalized) the user last completed a
  /// streak-qualifying action. Used to detect same-day / consecutive-day /
  /// broken-streak transitions.
  final DateTime? lastActiveDate;

  UserProgress copyWith({
    int? totalXp,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastActiveDate,
  }) {
    return UserProgress(
      totalXp: totalXp ?? this.totalXp,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgress &&
          other.totalXp == totalXp &&
          other.currentStreak == currentStreak &&
          other.bestStreak == bestStreak &&
          other.lastActiveDate == lastActiveDate);

  @override
  int get hashCode => Object.hash(totalXp, currentStreak, bestStreak, lastActiveDate);
}
