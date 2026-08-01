import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// Convenience shortcuts used throughout the widget layer. Keeping these
/// centralized avoids repeating `Theme.of(context)` / `AppLocalizations.of
/// (context)!` boilerplate in every widget.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  /// Localized strings for the current locale. Never hardcode user-facing
  /// copy in widgets — always go through this.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  void showSnack(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
