import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/animations/app_animations.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/models/task.dart';
import '../../domain/models/task_category.dart';
import '../../domain/models/task_priority.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.onToggleComplete,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.localId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.destructive.withOpacity(0.15),
          borderRadius: AppRadius.lgRadius,
        ),
        child: const Icon(Icons.delete_rounded, color: AppColors.destructive),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: Semantics(
        button: true,
        label: '${task.title}, ${task.priority.label} priority${task.isCompleted ? ', completed' : ''}',
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(color: AppColors.border),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: AppRadius.lgRadius,
            child: InkWell(
              borderRadius: AppRadius.lgRadius,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PriorityStrip(color: task.priority.color),
                    AppSpacing.gapMd,
                    _Checkbox(checked: task.isCompleted, onTap: onToggleComplete),
                    AppSpacing.gapMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: AppTypography.bodyLarge.copyWith(
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              color: task.isCompleted ? AppColors.mutedForeground : AppColors.foreground,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _CategoryDot(category: task.category),
                              if (task.dueDate != null) _DueDateChip(task: task),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.elevated,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        title: Text('Delete task?', style: AppTypography.h3),
        content: Text('"${task.title}" will be permanently deleted.', style: AppTypography.bodyMediumMuted),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: AppColors.destructive)),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

class _PriorityStrip extends StatelessWidget {
  const _PriorityStrip({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 44,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.checked, required this.onTap});

  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: checked,
      label: checked ? 'Mark as not done' : 'Mark as done',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          width: 26,
          height: 26,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: checked ? AppColors.primaryGradient : null,
            color: checked ? null : Colors.transparent,
            border: Border.all(color: checked ? Colors.transparent : AppColors.border, width: 2),
          ),
          child: checked
              ? const Icon(Icons.check_rounded, size: 16, color: AppColors.primaryForeground)
              : null,
        ),
      ),
    );
  }
}

class _CategoryDot extends StatelessWidget {
  const _CategoryDot({required this.category});

  final TaskCategory category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: category.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(category.label, style: AppTypography.labelSmall.copyWith(color: AppColors.mutedForeground)),
      ],
    );
  }
}

class _DueDateChip extends StatelessWidget {
  const _DueDateChip({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.isOverdue;
    final label = task.hasDueTime
        ? DateFormat('MMM d, h:mm a').format(task.dueDate!)
        : DateFormat('MMM d').format(task.dueDate!);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule_rounded, size: 12, color: isOverdue ? AppColors.destructive : AppColors.mutedForeground),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isOverdue ? AppColors.destructive : AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }
}
