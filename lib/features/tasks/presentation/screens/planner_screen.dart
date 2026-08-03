import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animations/animations.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/models/task_category.dart';
import '../../domain/models/task_priority.dart';
import '../providers/task_actions_controller.dart';
import '../providers/task_providers.dart';
import '../widgets/task_form_sheet.dart';
import '../widgets/task_tile.dart';

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(allTasksProvider);
    final filter = ref.watch(taskFilterControllerProvider);
    final filteredTasks = ref.watch(filteredTasksProvider);

    return Scaffold(
      appBar: const VyomAppBar(title: 'Planner'),
      body: tasksAsync.when(
        loading: () => const VyomLoadingIndicator(),
        error: (error, stackTrace) => ErrorState(onRetry: () => ref.invalidate(allTasksProvider)),
        data: (_) => Column(
          children: [
            Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  _SearchField(
                    onChanged: (q) => ref.read(taskFilterControllerProvider.notifier).setQuery(q),
                  ),
                  AppSpacing.gapMd,
                  _FilterTabs(
                    selected: filter.listFilter,
                    onChanged: (f) => ref.read(taskFilterControllerProvider.notifier).setListFilter(f),
                  ),
                  AppSpacing.gapMd,
                  _SortAndFilterRow(filter: filter),
                ],
              ),
            ),
            AppSpacing.gapSm,
            Expanded(
              child: filteredTasks.isEmpty
                  ? _EmptyPlannerState(filter: filter.listFilter)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.sm,
                        AppSpacing.lg,
                        100,
                      ),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return SlideInWidget(
                          delay: AppStagger.forIndex(index),
                          child: TaskTile(
                            task: task,
                            onToggleComplete: () => ref.read(taskActionsControllerProvider).toggleComplete(task),
                            onTap: () => showTaskFormSheet(context, task: task),
                            onDelete: () => ref.read(taskActionsControllerProvider).deleteTask(task.localId),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: VyomFloatingActionButton(
        icon: Icons.add_rounded,
        semanticLabel: 'Add task',
        onPressed: () => showTaskFormSheet(context),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: AppTypography.bodyMedium,
      decoration: const InputDecoration(
        hintText: 'Search tasks…',
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.mutedForeground),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.selected, required this.onChanged});

  final TaskListFilter selected;
  final ValueChanged<TaskListFilter> onChanged;

  static const _labels = {
    TaskListFilter.today: 'Today',
    TaskListFilter.upcoming: 'Upcoming',
    TaskListFilter.completed: 'Completed',
    TaskListFilter.overdue: 'Overdue',
    TaskListFilter.all: 'All',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: TaskListFilter.values.length,
        separatorBuilder: (_, __) => AppSpacing.gapSm,
        itemBuilder: (context, index) {
          final f = TaskListFilter.values[index];
          return VyomChip(label: _labels[f]!, selected: f == selected, onTap: () => onChanged(f));
        },
      ),
    );
  }
}

class _SortAndFilterRow extends ConsumerWidget {
  const _SortAndFilterRow({required this.filter});

  final TaskFilterState filter;

  static const _sortLabels = {
    TaskSort.dueDateAsc: 'Due date',
    TaskSort.priorityDesc: 'Priority',
    TaskSort.createdDesc: 'Newest',
    TaskSort.alphabetical: 'A–Z',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: PopupMenuButton<TaskSort>(
            initialValue: filter.sort,
            color: AppColors.elevated,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
            onSelected: (sort) => ref.read(taskFilterControllerProvider.notifier).setSort(sort),
            itemBuilder: (context) => TaskSort.values
                .map((s) => PopupMenuItem(value: s, child: Text(_sortLabels[s]!, style: AppTypography.bodyMedium)))
                .toList(),
            child: Row(
              children: [
                const Icon(Icons.sort_rounded, size: 18, color: AppColors.mutedForeground),
                const SizedBox(width: 6),
                Text('Sort: ${_sortLabels[filter.sort]}', style: AppTypography.labelMedium.copyWith(color: AppColors.mutedForeground)),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () => _showFilterSheet(context, ref),
          icon: Icon(
            Icons.filter_list_rounded,
            color: (filter.priorityFilter != null || filter.categoryFilter != null)
                ? AppColors.primary
                : AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.elevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Priority', style: AppTypography.h3),
            AppSpacing.gapMd,
            Wrap(
              spacing: AppSpacing.sm,
              children: TaskPriority.values
                  .map(
                    (p) => VyomChip(
                      label: p.label,
                      selected: filter.priorityFilter == p,
                      onTap: () => ref
                          .read(taskFilterControllerProvider.notifier)
                          .setPriorityFilter(filter.priorityFilter == p ? null : p),
                    ),
                  )
                  .toList(),
            ),
            AppSpacing.gapXl,
            Text('Filter by Category', style: AppTypography.h3),
            AppSpacing.gapMd,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: TaskCategory.values
                  .map(
                    (c) => VyomChip(
                      label: c.label,
                      icon: c.icon,
                      selected: filter.categoryFilter == c,
                      onTap: () => ref
                          .read(taskFilterControllerProvider.notifier)
                          .setCategoryFilter(filter.categoryFilter == c ? null : c),
                    ),
                  )
                  .toList(),
            ),
            AppSpacing.gapXl,
            VyomButton(
              label: 'Clear Filters',
              variant: VyomButtonVariant.secondary,
              expand: true,
              onPressed: () => ref.read(taskFilterControllerProvider.notifier).clearFilters(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPlannerState extends StatelessWidget {
  const _EmptyPlannerState({required this.filter});

  final TaskListFilter filter;

  @override
  Widget build(BuildContext context) {
    final (icon, title, message) = switch (filter) {
      TaskListFilter.today => (
          Icons.wb_sunny_outlined,
          'Nothing due today',
          'Enjoy the clear day, or add something you want to get done.'
        ),
      TaskListFilter.upcoming => (
          Icons.calendar_month_outlined,
          'No upcoming tasks',
          'Plan ahead by adding a task with a future due date.'
        ),
      TaskListFilter.completed => (
          Icons.task_alt_rounded,
          'Nothing completed yet',
          'Finished tasks will show up here.'
        ),
      TaskListFilter.overdue => (
          Icons.check_circle_outline_rounded,
          "You're all caught up",
          'No overdue tasks — nice work staying on top of things.'
        ),
      TaskListFilter.all => (
          Icons.inbox_outlined,
          'No tasks yet',
          'Tap the + button to create your first task.'
        ),
    };

    return EmptyState(icon: icon, title: title, message: message);
  }
}
