import 'package:flutter/material.dart';

/// Radius scale from `colors.md`: sm 0.625rem · md 0.875rem · lg 1.25rem ·
/// xl 1.75rem · 2xl 2.25rem · base(--radius) 1.25rem. Assuming 1rem = 16px.
abstract final class AppRadius {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20; // base --radius
  static const double xl = 28;
  static const double xxl = 36;

  static const double pill = 999;

  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);
  static BorderRadius get pillRadius => BorderRadius.circular(pill);

  const AppRadius._();
}
