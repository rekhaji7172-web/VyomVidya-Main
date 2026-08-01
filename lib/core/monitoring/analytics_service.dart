import 'logger_service.dart';

/// Abstract analytics interface. Business logic and UI code depend only on
/// this — never on `firebase_analytics` directly. This keeps analytics
/// separated from business logic (per architecture requirement) and makes
/// the provider swappable (Firebase now, PostHog/Mixpanel later) without
/// touching a single feature file.
abstract interface class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object?>? parameters});

  Future<void> setUserId(String? userId);

  Future<void> setUserProperty({required String name, required String? value});

  Future<void> logScreenView(String screenName);
}

/// Default implementation until `FirebaseAnalyticsService` is wired up in
/// the Firebase integration phase. Logs locally so events are still visible
/// during development instead of silently vanishing.
class NoOpAnalyticsService implements AnalyticsService {
  NoOpAnalyticsService(this._logger);

  final LoggerService _logger;

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    _logger.debug('[analytics] $name', parameters);
  }

  @override
  Future<void> setUserId(String? userId) async {
    _logger.debug('[analytics] setUserId', userId);
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) async {
    _logger.debug('[analytics] setUserProperty', '$name=$value');
  }

  @override
  Future<void> logScreenView(String screenName) async {
    _logger.debug('[analytics] screen_view', screenName);
  }
}
