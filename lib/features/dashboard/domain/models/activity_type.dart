import 'package:flutter/material.dart';

/// Kinds of events that can appear in the Recent Activity feed. Only
/// `taskCompleted`, `taskCreated`, and `xpEarned` are actually emitted in
/// Phase 2 (Tasks is the only feature that exists) — `timerFinished` and
/// `noteCreated` are defined now so Pomodoro/Notes can start writing
/// activity entries in later phases without a schema change.
enum ActivityType { taskCompleted, taskCreated, xpEarned, timerFinished, noteCreated }

extension ActivityTypeX on ActivityType {
  IconData get icon => switch (this) {
        ActivityType.taskCompleted => Icons.check_circle_rounded,
        ActivityType.taskCreated => Icons.add_task_rounded,
        ActivityType.xpEarned => Icons.bolt_rounded,
        ActivityType.timerFinished => Icons.timer_rounded,
        ActivityType.noteCreated => Icons.note_add_rounded,
      };
}
