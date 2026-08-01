import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/dashboard/data/activity_entry_hive_adapter.dart';
import '../../features/dashboard/data/user_progress_hive_adapter.dart';
import '../../features/dashboard/domain/models/activity_entry.dart';
import '../../features/dashboard/domain/models/user_progress.dart';
import '../../features/dashboard/presentation/providers/dashboard_providers.dart';
import '../../features/tasks/data/task_hive_adapter.dart';
import '../../features/tasks/domain/models/task.dart';
import '../../features/tasks/presentation/providers/task_providers.dart';
import '../constants/hive_box_names.dart';
import '../feature_flags/feature_flag_service.dart';
import 'service_providers.dart';

/// Runs all async setup that must complete before the widget tree is
/// built, then returns the [Override]s `main.dart` should pass into the
/// root [ProviderScope]. Keeping this out of `main()` itself makes the
/// bootstrap sequence unit-testable.
///
/// NOTE: Firebase.initializeApp() is intentionally NOT called here yet —
/// that's introduced in the dedicated Firebase integration phase.
Future<List<Override>> bootstrapApp() async {
  await Hive.initFlutter();

  // Each feature owns its adapter registration + box opening here — the
  // pattern anticipated since Phase 1 ("Feature-specific Hive
  // adapters/boxes are registered by each feature's data layer as those
  // features are built").
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(UserProgressAdapter());
  Hive.registerAdapter(ActivityEntryAdapter());

  final taskBox = await Hive.openBox<Task>(HiveBoxNames.tasks);
  final userProgressBox = await Hive.openBox<UserProgress>(HiveBoxNames.userProgress);
  final activityLogBox = await Hive.openBox<ActivityEntry>(HiveBoxNames.activityLog);

  final sharedPreferences = await SharedPreferences.getInstance();

  final overrides = <Override>[
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    taskBoxProvider.overrideWithValue(taskBox),
    userProgressBoxProvider.overrideWithValue(userProgressBox),
    activityLogBoxProvider.overrideWithValue(activityLogBox),
  ];

  return overrides;
}

/// Initializes services that depend on the provider container being ready
/// (e.g. feature flags need to fetch/refresh). Called once from `main()`
/// against the same [ProviderContainer] that's later handed to
/// [UncontrolledProviderScope].
Future<void> initializeRuntimeServices(ProviderContainer container) async {
  await container.read(featureFlagServiceProvider).initialize();
}
