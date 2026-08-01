import 'logger_service.dart';

/// Abstract crash-reporting interface. Implemented by
/// `FirebaseCrashlyticsService` once Firebase is wired up in a later phase.
abstract interface class CrashReportingService {
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
    Map<String, Object?>? context,
  });

  Future<void> setUserId(String? userId);

  Future<void> log(String message);
}

/// Development-time default: routes crash reports to the local logger so
/// nothing is silently lost before Crashlytics is connected.
class NoOpCrashReportingService implements CrashReportingService {
  NoOpCrashReportingService(this._logger);

  final LoggerService _logger;

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
    Map<String, Object?>? context,
  }) async {
    _logger.error(
      '[crash${fatal ? ':fatal' : ''}] $context',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  Future<void> setUserId(String? userId) async {
    _logger.debug('[crash] setUserId', userId);
  }

  @override
  Future<void> log(String message) async {
    _logger.debug('[crash] breadcrumb', message);
  }
}
