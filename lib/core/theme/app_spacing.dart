import 'package:flutter/widgets.dart';

/// Spacing scale used across VyomVidya. 4px base unit, matching the generous,
/// premium spacing rhythm called out in the design brief.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double massive = 56;

  /// Minimum touch target size (accessibility requirement — 48x48dp).
  static const double minTouchTarget = 48;

  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);
  static const SizedBox gapXxl = SizedBox(width: xxl, height: xxl);

  /// Standard screen horizontal padding.
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: lg);

  const AppSpacing._();
}
