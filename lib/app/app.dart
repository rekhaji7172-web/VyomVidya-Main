import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/locale_controller.dart';
import 'router/app_router.dart';

/// Root widget. Composes theme, routing, and localization. Kept
/// deliberately small — it wires things together and delegates everything
/// else to `core/` and `features/`.
class VyomVidyaApp extends ConsumerWidget {
  const VyomVidyaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      title: 'VyomVidya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) {
        // Clamp text scaling app-wide so extreme OS accessibility settings
        // don't break the premium layout, while still respecting the
        // user's preference (see AppBreakpoints / ResponsiveContext).
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: mediaQuery.textScaler.clamp(minScaleFactor: 0.85, maxScaleFactor: 1.4),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
