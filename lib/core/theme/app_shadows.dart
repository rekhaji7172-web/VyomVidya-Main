import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shadow presets matching the "beautiful shadows / premium blur" visual
/// language from the design brief. Kept subtle — VyomVidya never uses harsh
/// drop shadows.
abstract final class AppShadows {
  /// Soft elevation for cards resting on the base background.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  /// Stronger elevation for floating elements (bottom nav, FAB, sheets).
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 32,
      offset: Offset(0, 16),
    ),
  ];

  /// Purple glow used behind the AI Orb / primary gradient CTAs.
  static List<BoxShadow> primaryGlow({double opacity = 0.45}) => [
        BoxShadow(
          color: AppColors.primary.withOpacity(opacity),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ];

  /// Cyan-tinted glow, used sparingly for secondary accents.
  static List<BoxShadow> cyanGlow({double opacity = 0.35}) => [
        BoxShadow(
          color: AppColors.cyan.withOpacity(opacity),
          blurRadius: 26,
          offset: const Offset(0, 10),
        ),
      ];

  const AppShadows._();
}
