import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// The 4 priority levels a task can have. Order matters — index is used
/// for default sort-by-priority (urgent first).
enum TaskPriority { low, medium, high, urgent }

extension TaskPriorityX on TaskPriority {
  String get label => switch (this) {
        TaskPriority.low => 'Low',
        TaskPriority.medium => 'Medium',
        TaskPriority.high => 'High',
        TaskPriority.urgent => 'Urgent',
      };

  Color get color => switch (this) {
        TaskPriority.low => AppColors.success,
        TaskPriority.medium => AppColors.cyan,
        TaskPriority.high => AppColors.warning,
        TaskPriority.urgent => AppColors.destructive,
      };

  IconData get icon => switch (this) {
        TaskPriority.low => Icons.arrow_downward_rounded,
        TaskPriority.medium => Icons.remove_rounded,
        TaskPriority.high => Icons.arrow_upward_rounded,
        TaskPriority.urgent => Icons.priority_high_rounded,
      };

  /// XP awarded when a task of this priority is completed. Higher-effort
  /// (higher priority) tasks are worth more — see `XpSystem` in the
  /// dashboard feature for how this rolls up into levels.
  int get xpValue => switch (this) {
        TaskPriority.low => 10,
        TaskPriority.medium => 15,
        TaskPriority.high => 25,
        TaskPriority.urgent => 35,
      };
}
