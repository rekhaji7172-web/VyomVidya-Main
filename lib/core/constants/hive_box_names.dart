/// Central registry of Hive box names, mirroring [HiveTypeIds]. Keeps box
/// names discoverable in one place instead of string literals scattered
/// across `app_bootstrap.dart` and each feature's providers.
abstract final class HiveBoxNames {
  static const String tasks = 'tasks_box';
  static const String userProgress = 'user_progress_box';
  static const String activityLog = 'activity_log_box';

  const HiveBoxNames._();
}
