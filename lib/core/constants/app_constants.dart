/// App-wide constants that don't belong to any single feature.
abstract final class AppConstants {
  static const String appName = 'VyomVidya';

  /// SharedPreferences keys.
  static const String prefsKeyLocale = 'app_locale';
  static const String prefsKeyOnboardingComplete = 'onboarding_complete';
  static const String prefsKeyThemeMode = 'theme_mode'; // reserved; dark-only for now
  static const String prefsKeyUserName = 'user_display_name'; // set by Profile feature (Phase 3+)

  /// Supported locales (English ships now; Hindi is architecture-ready —
  /// add its ARB file and this list entry together when translations land).
  static const List<String> supportedLocaleCodes = ['en'];

  const AppConstants._();
}
