import 'package:flutter/foundation.dart';

import '../../../../core/sync/sync_status.dart';
import '../../../../core/sync/syncable.dart';
import 'task_category.dart';
import 'task_priority.dart';

/// A single planner/task entry. Implements [Syncable] so it plugs directly
/// into the offline-first sync engine built in Phase 1 (no code changes
/// needed there when a remote backend is added later).
///
/// Hand-written immutable class (see Phase 2 kickoff note on why this
/// isn't `@freezed` yet) — `copyWith`, `==`, `hashCode` are all manual but
/// follow exactly the shape freezed would generate, so converting later is
/// a mechanical, low-risk change.
@immutable
class Task implements Syncable {
  const Task({
    required this.localId,
    required this.title,
    required this.priority,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.remoteId,
    this.description,
    this.dueDate,
    this.hasDueTime = false,
    this.isCompleted = false,
    this.completedAt,
    this.syncStatus = SyncStatus.synced,
  });

  @override
  final String localId;

  @override
  final String? remoteId;

  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskCategory category;

  /// Date (and, if [hasDueTime] is true, meaningful time-of-day) the task
  /// is due. Null means "no due date" (a someday/backlog task).
  final DateTime? dueDate;

  /// Whether [dueDate]'s time component was explicitly set by the user, or
  /// whether it should be treated as "due sometime that day" for display.
  final bool hasDueTime;

  final bool isCompleted;
  final DateTime? completedAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  final SyncStatus syncStatus;

  bool get hasDueDate => dueDate != null;

  bool get isOverdue {
    if (isCompleted || dueDate == null) return false;
    final now = DateTime.now();
    final due = dueDate!;
    final endOfDueDay = DateTime(due.year, due.month, due.day, 23, 59, 59);
    return now.isAfter(endOfDueDay);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year && dueDate!.month == now.month && dueDate!.day == now.day;
  }

  bool get isUpcoming {
    if (isCompleted || dueDate == null) return false;
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    return dueDate!.isAfter(startOfToday) && !isDueToday;
  }

  Task copyWith({
    String? localId,
    String? remoteId,
    bool clearRemoteId = false,
    String? title,
    String? description,
    bool clearDescription = false,
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? dueDate,
    bool clearDueDate = false,
    bool? hasDueTime,
    bool? isCompleted,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return Task(
      localId: localId ?? this.localId,
      remoteId: clearRemoteId ? null : (remoteId ?? this.remoteId),
      title: title ?? this.title,
      description: clearDescription ? null : (description ?? this.description),
      priority: priority ?? this.priority,
      category: category ?? this.category,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      hasDueTime: hasDueTime ?? this.hasDueTime,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.localId == localId &&
        other.remoteId == remoteId &&
        other.title == title &&
        other.description == description &&
        other.priority == priority &&
        other.category == category &&
        other.dueDate == dueDate &&
        other.hasDueTime == hasDueTime &&
        other.isCompleted == isCompleted &&
        other.completedAt == completedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.syncStatus == syncStatus;
  }

  @override
  int get hashCode => Object.hash(
        localId,
        remoteId,
        title,
        description,
        priority,
        category,
        dueDate,
        hasDueTime,
        isCompleted,
        completedAt,
        createdAt,
        updatedAt,
        syncStatus,
      );

  @override
  String toString() => 'Task(localId: $localId, title: $title, priority: $priority, '
      'completed: $isCompleted, dueDate: $dueDate)';
}
