import 'package:flutter/material.dart';

/// Color tokens extracted 1:1 from the VyomVidya V0 design system
/// (`Colors/colors.md`, derived from `app/globals.css`).
///
/// Dark-first: these are the only palette VyomVidya V2 ships with for now.
/// Do not introduce ad-hoc colors outside this file — see Design Consistency
/// rules in the project knowledge base.
abstract final class AppColors {
  // ---- Base (dark theme root) ----
  static const Color background = Color(0xFF0D0D14);
  static const Color foreground = Color(0xFFF1F0FF);
  static const Color surface = Color(0xFF13131F);
  static const Color elevated = Color(0xFF1A1A2E);
  static const Color hover = Color(0xFF1F1F35);
  static const Color card = Color(0xFF13131F);
  static const Color cardForeground = Color(0xFFF1F0FF);
  static const Color popover = Color(0xFF1A1A2E);
  static const Color popoverForeground = Color(0xFFF1F0FF);

  // ---- Brand ----
  static const Color primary = Color(0xFF8B5CF6); // Deep Purple
  static const Color primaryForeground = Color(0xFFF7F5FF);
  static const Color secondary = Color(0xFF1A1A2E);
  static const Color secondaryForeground = Color(0xFFF1F0FF);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color muted = Color(0xFF1A1A2E);
  static const Color mutedForeground = Color(0xFFA09EB8);
  static const Color subtleMuted = Color(0xFF5C5A7A); // "Muted" text tone from brief

  // ---- Status ----
  static const Color destructive = Color(0xFFF4587A);
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFF5B942);

  // ---- Structure ----
  static const Color border = Color(0xFF2A2840);
  static const Color input = Color(0xFF2A2840);
  static const Color ring = Color(0xFF8B5CF6);

  // ---- Rank / League tiers ----
  static const Color leagueBronze = Color(0xFFCD7F32);
  static const Color leagueSilver = Color(0xFFB8C0CC);
  static const Color leagueGold = Color(0xFFF5B942);
  static const Color leaguePlatinum = Color(0xFF8FE3D6);
  static const Color leagueDiamond = Color(0xFF5AD1FF);
  static const Color leagueMaster = Color(0xFFB07CFF);
  static const Color leagueMythic = Color(0xFFFF6AD5);

  // ---- Gradients ----
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, cyan],
  );

  /// Ambient page background glow used behind hero content (top-right purple,
  /// bottom-left cyan) — mirrors the radial gradients in `app/page.tsx`.
  static const RadialGradient ambientTopRight = RadialGradient(
    center: Alignment(0.6, -1.0),
    radius: 1.2,
    colors: [Color(0x298B5CF6), Colors.transparent],
  );

  static const RadialGradient ambientBottomLeft = RadialGradient(
    center: Alignment(-1.0, 1.0),
    radius: 1.0,
    colors: [Color(0x1A06B6D4), Colors.transparent],
  );

  const AppColors._();
}
