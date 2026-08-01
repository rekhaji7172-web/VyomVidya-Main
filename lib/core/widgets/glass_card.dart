import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// The signature "glassmorphism" card from the VyomVidya design system:
/// translucent surface, blur, soft border, subtle shadow. Used for
/// elevated content — mission cards, stat cards, session cards.
///
/// Matches `GlassCard` in the V0 `primitives.tsx`.
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderRadius,
    this.blurSigma = 20,
    this.tint,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final double blurSigma;
  final Color? tint;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.lgRadius;

    final content = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: (tint ?? AppColors.elevated).withOpacity(0.55),
            borderRadius: radius,
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.card,
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) {
      return Semantics(container: true, label: semanticLabel, child: content);
    }

    return Semantics(
      container: true,
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: content,
        ),
      ),
    );
  }
}
