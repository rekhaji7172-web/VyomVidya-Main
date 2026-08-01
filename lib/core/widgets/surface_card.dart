import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Solid (non-blurred) card — cheaper than [GlassCard] and used where a
/// backdrop blur isn't warranted (e.g. list items, chips-in-a-row
/// backgrounds, nested cards). Matches `SurfaceCard` in `primitives.tsx`.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderRadius,
    this.color,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.lgRadius;

    final container = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: radius,
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );

    if (onTap == null) {
      return Semantics(container: true, label: semanticLabel, child: container);
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
          child: container,
        ),
      ),
    );
  }
}
