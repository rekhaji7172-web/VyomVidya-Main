import 'logger_service.dart';

/// Abstract performance-trace interface. Implemented by
/// `FirebasePerformanceService` once Firebase is wired up.
///
/// Usage pattern:
/// ```dart
/// final trace = await performanceService.startTrace('ai_response_time');
/// // ... do work ...
/// await trace.stop();
/// ```
abstract interface class PerformanceMonitoringService {
  Future<PerformanceTrace> startTrace(String name);
}

abstract interface class PerformanceTrace {
  void putAttribute(String key, String value);
  Future<void> stop();
}

class NoOpPerformanceMonitoringService implements PerformanceMonitoringService {
  NoOpPerformanceMonitoringService(this._logger);

  final LoggerService _logger;

  @override
  Future<PerformanceTrace> startTrace(String name) async {
    _logger.debug('[perf] trace started', name);
    return _NoOpTrace(name, _logger);
  }
}

class _NoOpTrace implements PerformanceTrace {
  _NoOpTrace(this._name, this._logger) : _stopwatch = Stopwatch()..start();

  final String _name;
  final LoggerService _logger;
  final Stopwatch _stopwatch;

  @override
  void putAttribute(String key, String value) {
    _logger.debug('[perf] $_name attribute', '$key=$value');
  }

  @override
  Future<void> stop() async {
    _stopwatch.stop();
    _logger.debug('[perf] trace stopped', '$_name (${_stopwatch.elapsedMilliseconds}ms)');
  }
}
