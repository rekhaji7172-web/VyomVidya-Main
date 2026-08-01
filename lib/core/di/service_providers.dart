import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../feature_flags/feature_flag_service.dart';
import '../monitoring/analytics_service.dart';
import '../monitoring/crash_reporting_service.dart';
import '../monitoring/logger_service.dart';
import '../monitoring/performance_monitoring_service.dart';
import '../sync/connectivity_service.dart';
import '../sync/sync_queue.dart';

/// -----------------------------------------------------------------------
/// Dependency-injection root. Every cross-cutting service is exposed here
/// as a Riverpod [Provider] typed to its ABSTRACT interface — features
/// depend on `analyticsServiceProvider`, never on `FirebaseAnalytics`
/// directly. Swapping an implementation (e.g. Firebase → another vendor,
/// or Local → Remote feature flags) means changing exactly one line below.
/// -----------------------------------------------------------------------

/// Must be overridden in `main.dart` with the real instance obtained via
/// `await SharedPreferences.getInstance()` before `runApp`. Left
/// unimplemented here so a missing override fails loudly instead of
/// silently using a broken default.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden in main.dart'),
);

final loggerServiceProvider = Provider<LoggerService>((ref) => LoggerService());

final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => NoOpAnalyticsService(ref.watch(loggerServiceProvider)),
);

final crashReportingServiceProvider = Provider<CrashReportingService>(
  (ref) => NoOpCrashReportingService(ref.watch(loggerServiceProvider)),
);

final performanceMonitoringServiceProvider = Provider<PerformanceMonitoringService>(
  (ref) => NoOpPerformanceMonitoringService(ref.watch(loggerServiceProvider)),
);

final featureFlagServiceProvider = Provider<FeatureFlagService>((ref) => LocalFeatureFlagService());

final connectivityServiceProvider = Provider<ConnectivityService>((ref) => ConnectivityService());

final syncQueueProvider = Provider<SyncQueue>((ref) {
  final queue = SyncQueue(
    connectivityService: ref.watch(connectivityServiceProvider),
    logger: ref.watch(loggerServiceProvider),
  );
  ref.onDispose(queue.dispose);
  return queue;
});
