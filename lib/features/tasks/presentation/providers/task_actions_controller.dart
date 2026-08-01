import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/result.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../domain/models/task.dart';
import '../../domain/models/task_category.dart';
import '../../domain/models/task_priority.dart';
import 'task_providers.dart';

const _uuid = Uuid();

/// Coordinates task CRUD with its cross-feature side effects (XP, streak,
/// activity feed). This composition intentionally lives at the
/// presentation layer, not inside either repository — `TaskRepository`
/// and `ProgressRepository` stay independent and swappable; only this
/// controller knows "completing a task also awards XP".
class TaskActionsController {
  TaskActionsController(this._ref);

  final Ref _ref;

  Future<Result<Task>> createTask({
    required String title,
    String? description,
    required TaskPriority priority,
    required TaskCategory category,
    DateTime? dueDate,
    bool hasDueTime = false,
  }) async {
    final now = DateTime.now();
    final task = Task(
      localId: _uuid.v4(),
      title: title.trim(),
      description: (description?.trim().isEmpty ?? true) ? null : description!.trim(),
      priority: priority,
      category: category,
      dueDate: dueDate,
      hasDueTime: hasDueTime,
      createdAt: now,
      updatedAt: now,
    );

    final result = await _ref.read(taskRepositoryProvider).create(task);
    if (result.isSuccess) {
      await _ref.read(progressRepositoryProvider).recordTaskCreated(taskTitle: task.title);
    }
    return result;
  }

  Future<Result<Task>> updateTask(
    Task original, {
    required String title,
    String? description,
    required TaskPriority priority,
    required TaskCategory category,
    DateTime? dueDate,
    bool clearDueDate = false,
    bool hasDueTime = false,
  }) async {
    final updated = original.copyWith(
      title: title.trim(),
      description: (description?.trim().isEmpty ?? true) ? null : description!.trim(),
      clearDescription: description == null || description.trim().isEmpty,
      priority: priority,
      category: category,
      dueDate: dueDate,
      clearDueDate: clearDueDate,
      hasDueTime: hasDueTime,
      updatedAt: DateTime.now(),
    );
    return _ref.read(taskRepositoryProvider).update(updated);
  }

  Future<Result<void>> deleteTask(String localId) {
    return _ref.read(taskRepositoryProvider).delete(localId);
  }

  /// Flips [task.isCompleted] and applies the matching XP/streak effect.
  Future<Result<Task>> toggleComplete(Task task) async {
    final now = DateTime.now();
    final willComplete = !task.isCompleted;

    final updated = task.copyWith(
      isCompleted: willComplete,
      completedAt: willComplete ? now : null,
      clearCompletedAt: !willComplete,
      updatedAt: now,
    );

    final result = await _ref.read(taskRepositoryProvider).update(updated);
    if (result.isSuccess) {
      final progressRepo = _ref.read(progressRepositoryProvider);
      if (willComplete) {
        await progressRepo.recordTaskCompleted(taskTitle: task.title, xp: task.priority.xpValue);
      } else {
        await progressRepo.revertTaskCompletion(xp: task.priority.xpValue);
      }
    }
    return result;
  }
}

final taskActionsControllerProvider = Provider<TaskActionsController>((ref) => TaskActionsController(ref));
