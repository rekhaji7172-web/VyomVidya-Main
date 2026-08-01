import 'package:flutter/widgets.dart';

/// Breakpoints and helpers so no screen/widget hardcodes device sizes.
/// Values chosen to comfortably split small Android phones, large phones,
/// and tablets (foldables land in the tablet bucket once unfolded).
abstract final class AppBreakpoints {
  static const double compact = 360; // small phones (e.g. older/budget Android)
  static const double medium = 600; // large phones / small foldables
  static const double expanded = 840; // tablets

  const AppBreakpoints._();
}

enum DeviceSize { compact, medium, expanded }

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  DeviceSize get deviceSize {
    final width = screenWidth;
    if (width >= AppBreakpoints.expanded) return DeviceSize.expanded;
    if (width >= AppBreakpoints.medium) return DeviceSize.medium;
    return DeviceSize.compact;
  }

  bool get isCompact => deviceSize == DeviceSize.compact;
  bool get isTablet => deviceSize == DeviceSize.expanded;

  /// Picks a value based on the current [DeviceSize], falling back down
  /// the scale (expanded → medium → compact) if a size isn't provided.
  /// Example: `context.responsive(compact: 16, expanded: 32)`.
  T responsive<T>({required T compact, T? medium, T? expanded}) {
    switch (deviceSize) {
      case DeviceSize.expanded:
        return expanded ?? medium ?? compact;
      case DeviceSize.medium:
        return medium ?? compact;
      case DeviceSize.compact:
        return compact;
    }
  }

  /// Clamps text scaling so premium layouts don't break at extreme
  /// accessibility text-size settings, while still respecting the user's
  /// preference (never disable text scaling outright — see Accessibility
  /// principles).
  TextScaler get clampedTextScaler =>
      MediaQuery.textScalerOf(this).clamp(minScaleFactor: 0.85, maxScaleFactor: 1.4);
}
