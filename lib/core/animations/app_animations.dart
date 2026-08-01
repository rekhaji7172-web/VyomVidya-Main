import 'package:flutter/animation.dart';

/// Central animation constants. All reusable animation widgets in
/// `core/animations` and `core/widgets` should pull durations/curves from
/// here rather than hardcoding values, matching the "smooth, natural,
/// purposeful, never distracting" animation philosophy.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 500);

  /// Long ambient/looping animations (floating, breathing, glow pulses).
  static const Duration ambientFloat = Duration(milliseconds: 3000);
  static const Duration ambientPulse = Duration(milliseconds: 2000);
  static const Duration ambientGlow = Duration(milliseconds: 2400);

  const AppDurations._();
}

abstract final class AppCurves {
  /// Spring-like ease used for entrances (mirrors CSS spring easing).
  static const Curve springOut = Curves.easeOutBack;
  static const Curve springInOut = Curves.easeInOutCubic;

  static const Curve standard = Curves.easeOutCubic;
  static const Curve decelerate = Curves.decelerate;
  static const Curve gentle = Curves.easeInOut;

  const AppCurves._();
}
