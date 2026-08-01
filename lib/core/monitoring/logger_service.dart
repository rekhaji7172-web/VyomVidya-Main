import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Thin wrapper around `package:logger` so the rest of the app depends on
/// this interface, not the third-party package directly (consistent with
/// the dependency-inversion rule — swapping logging backends later touches
/// only this file).
class LoggerService {
  LoggerService()
      : _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 1,
            errorMethodCount: 8,
            lineLength: 100,
            colors: true,
            printEmojis: true,
          ),
          level: kReleaseMode ? Level.warning : Level.debug,
        );

  final Logger _logger;

  void debug(String message, [Object? data]) => _logger.d(_withData(message, data));

  void info(String message, [Object? data]) => _logger.i(_withData(message, data));

  void warning(String message, [Object? data]) => _logger.w(_withData(message, data));

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  String _withData(String message, Object? data) => data == null ? message : '$message | $data';
}
