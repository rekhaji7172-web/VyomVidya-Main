import 'package:flutter/foundation.dart';

import 'activity_type.dart';

@immutable
class ActivityEntry {
  const ActivityEntry({
    required this.type,
    required this.title,
    required this.timestamp,
    this.xpDelta = 0,
  });

  final ActivityType type;
  final String title;
  final DateTime timestamp;

  /// XP gained from this event, if any (shown as a "+N XP" suffix).
  final int xpDelta;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityEntry &&
          other.type == type &&
          other.title == title &&
          other.timestamp == timestamp &&
          other.xpDelta == xpDelta);

  @override
  int get hashCode => Object.hash(type, title, timestamp, xpDelta);
}
