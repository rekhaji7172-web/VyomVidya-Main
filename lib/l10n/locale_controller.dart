import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/di/service_providers.dart';

/// Holds the app's active [Locale]. Defaults to English. Switching locale
/// (e.g. from Settings, once that screen exists) just calls
/// `ref.read(localeControllerProvider.notifier).setLocale(const Locale('hi'))`
/// — no widget needs to know how the preference is persisted.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    final saved = ref.read(sharedPreferencesProvider).getString(AppConstants.prefsKeyLocale);
    if (saved != null && AppConstants.supportedLocaleCodes.contains(saved)) {
      return Locale(saved);
    }
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    if (!AppConstants.supportedLocaleCodes.contains(locale.languageCode)) {
      throw ArgumentError('Unsupported locale: ${locale.languageCode}');
    }
    state = locale;
    await ref.read(sharedPreferencesProvider).setString(AppConstants.prefsKeyLocale, locale.languageCode);
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(LocaleController.new);
