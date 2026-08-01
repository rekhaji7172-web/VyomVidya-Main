import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/di/service_providers.dart';
import '../../../../core/monitoring/monitoring.dart';
import '../../data/hive_task_repository.dart';
import '../../domain/models/task.dart';
import '../../domain/models/task_category.dart';
import '../../domain/models/task_priority.dart';
import '../../domain/repositories/task_repository.dart';

/// Must be overridden in `app_bootstrap.dart` with the opened
/// `Box<Task>` before `runApp` — same guard pattern as
/// `sharedPreferencesProvider` in `core/di/service_providers.dart`.
final taskBoxProvider = Provider<Box<Task>>(
  (ref) => throw UnimplementedError('taskBoxProvider must be overridden in app_bootstrap.dart'),
);

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final repository = HiveTaskRepository(
    box: ref.watch(taskBoxProvider),
    logger: ref.watch(loggerServiceProvider),
  );
  ref.watch(syncQueueProvider).register(repository);
  return repository;
});

/// Live stream of every task — every filtered view below derives from
/// this single provider so there's exactly one Hive listener per screen,
/// not one per filter.
final allTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(taskRepositoryProvider).watchAll();
});

enum TaskSort { dueDateAsc, priorityDesc, createdDesc, alphabetical }

enum TaskListFilter { today, upcoming, completed, overdue, all }

class TaskFilterState {
  const TaskFilterState({
    this.query = '',
    this.listFilter = TaskListFilter.today,
    this.sort = TaskSort.dueDateAsc,
    this.priorityFilter,
    this.categoryFilter,
  });

  final String query;
  final TaskListFilter listFilter;
  final TaskSort sort;
  final TaskPriority? priorityFilter;
  final TaskCategory? categoryFilter;

  TaskFilterState copyWith({
    String? query,
    TaskListFilter? listFilter,
    TaskSort? sort,
    TaskPriority? priorityFilter,
    bool clearPriorityFilter = false,
    TaskCategory? categoryFilter,
    bool clearCategoryFilter = false,
  }) {
    return TaskFilterState(
      query: query ?? this.query,
      listFilter: listFilter ?? this.listFilter,
      sort: sort ?? this.sort,
      priorityFilter: clearPriorityFilter ? null : (priorityFilter ?? this.priorityFilter),
      categoryFilter: clearCategoryFilter ? null : (categoryFilter ?? this.categoryFilter),
    );
  }
}

class TaskFilterController extends Notifier<TaskFilterState> {
  @override
  TaskFilterState build() => const TaskFilterState();

  void setQuery(String query) => state = state.copyWith(query: query);

  void setListFilter(TaskListFilter filter) => state = state.copyWith(listFilter: filter);

  void setSort(TaskSort sort) => state = state.copyWith(sort: sort);

  void setPriorityFilter(TaskPriority? priority) =>
      state = state.copyWith(priorityFilter: priority, clearPriorityFilter: priority == null);

  void setCategoryFilter(TaskCategory? category) =>
      state = state.copyWith(categoryFilter: category, clearCategoryFilter: category == null);

  void clearFilters() => state = TaskFilterState(listFilter: state.listFilter);
}

final taskFilterControllerProvider = NotifierProvider<TaskFilterController, TaskFilterState>(
  TaskFilterController.new,
);

/// The fully filtered + sorted task list the Planner screen renders.
/// Recomputed whenever the raw task stream or filter state changes.
final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasksAsync = ref.watch(allTasksProvider);
  final filter = ref.watch(taskFilterControllerProvider);
  final tasks = tasksAsync.value ?? const <Task>[];

  var result = tasks.where((task) {
    switch (filter.listFilter) {
      case TaskListFilter.today:
        return task.isDueToday && !task.isCompleted;
      case TaskListFilter.upcoming:
        return task.isUpcoming;
      case TaskListFilter.completed:
        return task.isCompleted;
      case TaskListFilter.overdue:
        return task.isOverdue;
      case TaskListFilter.all:
        return true;
    }
  }).toList();

  if (filter.priorityFilter != null) {
    result = result.where((t) => t.priority == filter.priorityFilter).toList();
  }
  if (filter.categoryFilter != null) {
    result = result.where((t) => t.category == filter.categoryFilter).toList();
  }
  if (filter.query.trim().isNotEmpty) {
    final q = filter.query.trim().toLowerCase();
    result = result
        .where((t) => t.title.toLowerCase().contains(q) || (t.description ?? '').toLowerCase().contains(q))
        .toList();
  }

  result.sort((a, b) {
    switch (filter.sort) {
      case TaskSort.dueDateAsc:
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      case TaskSort.priorityDesc:
        return b.priority.index.compareTo(a.priority.index);
      case TaskSort.createdDesc:
        return b.createdAt.compareTo(a.createdAt);
      case TaskSort.alphabetical:
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    }
  });

  return result;
});

/// Today's incomplete tasks — used by both the Planner "Today" tab and the
/// Dashboard's planner-preview card, so both stay in sync automatically.
final todayTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(allTasksProvider).value ?? const <Task>[];
  final today = tasks.where((t) => t.isDueToday).toList()
    ..sort((a, b) => a.priority.index == b.priority.index
        ? (a.dueDate ?? DateTime(0)).compareTo(b.dueDate ?? DateTime(0))
        : b.priority.index.compareTo(a.priority.index));
  return today;
});
