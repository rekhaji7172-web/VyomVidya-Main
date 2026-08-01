import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography scale matching the V0 design system:
/// - Headings → Plus Jakarta Sans
/// - Body     → DM Sans
/// - Mono     → JetBrains Mono (stats / numeric emphasis)
abstract final class AppTypography {
  static TextStyle get _headingBase => GoogleFonts.plusJakartaSans(
        color: AppColors.foreground,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get _bodyBase => GoogleFonts.dmSans(
        color: AppColors.foreground,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get _monoBase => GoogleFonts.jetBrainsMono(
        color: AppColors.foreground,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // ---- Display / Headings ----
  static TextStyle get display => _headingBase.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      );

  static TextStyle get h1 => _headingBase.copyWith(fontSize: 28, letterSpacing: -0.3);
  static TextStyle get h2 => _headingBase.copyWith(fontSize: 24, letterSpacing: -0.2);
  static TextStyle get h3 => _headingBase.copyWith(fontSize: 20);
  static TextStyle get title => _headingBase.copyWith(fontSize: 17, fontWeight: FontWeight.w600);

  // ---- Body ----
  static TextStyle get bodyLarge => _bodyBase.copyWith(fontSize: 16);
  static TextStyle get bodyMedium => _bodyBase.copyWith(fontSize: 14);
  static TextStyle get bodySmall => _bodyBase.copyWith(fontSize: 12);

  static TextStyle get bodyLargeMuted => bodyLarge.copyWith(color: AppColors.mutedForeground);
  static TextStyle get bodyMediumMuted => bodyMedium.copyWith(color: AppColors.mutedForeground);
  static TextStyle get bodySmallMuted => bodySmall.copyWith(color: AppColors.mutedForeground);

  // ---- Labels / Buttons ----
  static TextStyle get labelLarge => _bodyBase.copyWith(fontSize: 15, fontWeight: FontWeight.w600);
  static TextStyle get labelMedium => _bodyBase.copyWith(fontSize: 13, fontWeight: FontWeight.w600);
  static TextStyle get labelSmall => _bodyBase.copyWith(fontSize: 11, fontWeight: FontWeight.w600);

  // ---- Mono (stats, XP counters, timers) ----
  static TextStyle get monoLarge => _monoBase.copyWith(fontSize: 22);
  static TextStyle get monoMedium => _monoBase.copyWith(fontSize: 16);
  static TextStyle get monoSmall => _monoBase.copyWith(fontSize: 13);

  const AppTypography._();
}
