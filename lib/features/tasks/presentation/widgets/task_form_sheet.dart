import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/result.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/models/task.dart';
import '../../domain/models/task_category.dart';
import '../../domain/models/task_priority.dart';
import '../providers/task_actions_controller.dart';
import 'category_selector.dart';
import 'priority_selector.dart';

/// Opens the create/edit task form as a modal bottom sheet. Pass [task] to
/// edit an existing one; omit it to create a new task.
Future<void> showTaskFormSheet(BuildContext context, {Task? task}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TaskFormSheet(task: task),
  );
}

class TaskFormSheet extends ConsumerStatefulWidget {
  const TaskFormSheet({this.task, super.key});

  final Task? task;

  @override
  ConsumerState<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends ConsumerState<TaskFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TaskPriority _priority;
  late TaskCategory _category;
  DateTime? _dueDate;
  bool _hasDueTime = false;
  bool _isSaving = false;
  String? _titleError;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _priority = task?.priority ?? TaskPriority.medium;
    _category = task?.category ?? TaskCategory.study;
    _dueDate = task?.dueDate;
    _hasDueTime = task?.hasDueTime ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.elevated,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(_isEditing ? 'Edit Task' : 'New Task', style: AppTypography.h2),
                AppSpacing.gapXl,
                _buildTitleField(),
                AppSpacing.gapLg,
                _buildDescriptionField(),
                AppSpacing.gapXl,
                Text('Priority', style: AppTypography.labelLarge),
                AppSpacing.gapSm,
                PrioritySelector(selected: _priority, onChanged: (p) => setState(() => _priority = p)),
                AppSpacing.gapXl,
                Text('Category', style: AppTypography.labelLarge),
                AppSpacing.gapSm,
                CategorySelector(selected: _category, onChanged: (c) => setState(() => _category = c)),
                AppSpacing.gapXl,
                Text('Due Date', style: AppTypography.labelLarge),
                AppSpacing.gapSm,
                _buildDueDateRow(context),
                AppSpacing.gapXxl,
                SaveTaskButton(isSaving: _isSaving, isEditing: _isEditing, onPressed: _save),
                if (_isEditing) ...[
                  AppSpacing.gapSm,
                  Center(
                    child: TextButton(
                      onPressed: _isSaving ? null : _delete,
                      child: const Text('Delete Task', style: TextStyle(color: AppColors.destructive)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      autofocus: !_isEditing,
      textCapitalization: TextCapitalization.sentences,
      style: AppTypography.bodyLarge,
      decoration: InputDecoration(
        labelText: 'Task title',
        hintText: 'e.g. Revise Organic Chemistry Ch. 4',
        errorText: _titleError,
      ),
      onChanged: (_) {
        if (_titleError != null) setState(() => _titleError = null);
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
      style: AppTypography.bodyMedium,
      decoration: const InputDecoration(
        labelText: 'Notes (optional)',
        hintText: 'Add any details…',
      ),
    );
  }

  Widget _buildDueDateRow(BuildContext context) {
    final label = _dueDate == null
        ? 'No due date'
        : (_hasDueTime ? DateFormat('EEE, MMM d · h:mm a').format(_dueDate!) : DateFormat('EEE, MMM d').format(_dueDate!));

    return Row(
      children: [
        Expanded(
          child: SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            onTap: _pickDueDate,
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 18, color: _dueDate == null ? AppColors.mutedForeground : AppColors.primary),
                AppSpacing.gapSm,
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: _dueDate == null ? AppColors.mutedForeground : AppColors.foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_dueDate != null) ...[
          AppSpacing.gapSm,
          IconButton(
            onPressed: () => setState(() {
              _dueDate = null;
              _hasDueTime = false;
            }),
            icon: const Icon(Icons.close_rounded, color: AppColors.mutedForeground),
          ),
        ],
      ],
    );
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null || !mounted) return;

    final addTime = await _confirmAddTime();
    if (!mounted) return;

    if (addTime) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? now),
      );
      if (!mounted) return;
      setState(() {
        _hasDueTime = time != null;
        _dueDate = time != null
            ? DateTime(picked.year, picked.month, picked.day, time.hour, time.minute)
            : DateTime(picked.year, picked.month, picked.day);
      });
    } else {
      setState(() {
        _hasDueTime = false;
        _dueDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<bool> _confirmAddTime() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.elevated,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        title: Text('Set a time?', style: AppTypography.h3),
        content: Text('Add a specific time, or just set the date.', style: AppTypography.bodyMediumMuted),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Just the date')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Add time')),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = 'Give your task a title');
      return;
    }

    setState(() => _isSaving = true);
    final controller = ref.read(taskActionsControllerProvider);

    final result = widget.task == null
        ? await controller.createTask(
            title: title,
            description: _descriptionController.text,
            priority: _priority,
            category: _category,
            dueDate: _dueDate,
            hasDueTime: _hasDueTime,
          )
        : await controller.updateTask(
            widget.task!,
            title: title,
            description: _descriptionController.text,
            priority: _priority,
            category: _category,
            dueDate: _dueDate,
            clearDueDate: _dueDate == null,
            hasDueTime: _hasDueTime,
          );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (result.isSuccess) {
      Navigator.of(context).pop();
    } else if (result case ResultError(:final failure)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  Future<void> _delete() async {
    final task = widget.task;
    if (task == null) return;
    setState(() => _isSaving = true);
    await ref.read(taskActionsControllerProvider).deleteTask(task.localId);
    if (mounted) Navigator.of(context).pop();
  }
}

/// Thin wrapper so the primary CTA reads "Create Task" / "Save Changes"
/// without duplicating [VyomButton]'s loading logic inline in
/// [_TaskFormSheetState.build].
class SaveTaskButton extends StatelessWidget {
  const SaveTaskButton({required this.isSaving, required this.isEditing, required this.onPressed, super.key});

  final bool isSaving;
  final bool isEditing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VyomButton(
      label: isEditing ? 'Save Changes' : 'Create Task',
      isLoading: isSaving,
      expand: true,
      onPressed: isSaving ? null : onPressed,
    );
  }
}
