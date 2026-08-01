import 'package:flutter/material.dart';

import '../animations/app_animations.dart';
import '../theme/theme.dart';

/// Linear progress bar with gradient fill and animated growth. Matches
/// `ProgressBar` in `primitives.tsx` — used for XP-to-next-level, water-to
/// -evolve, focus-time-goal progress.
class VyomProgressBar extends StatelessWidget {
  const VyomProgressBar({
    required this.progress,
    this.height = 10,
    this.gradient,
    this.trackColor,
    this.semanticLabel,
    super.key,
  });

  /// 0.0–1.0. Values outside this range are clamped.
  final double progress;
  final double height;
  final Gradient? gradient;
  final Color? trackColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return Semantics(
      label: semanticLabel,
      value: '${(clamped * 100).round()}%',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: Container(
          height: height,
          color: trackColor ?? AppColors.surface,
          alignment: Alignment.centerLeft,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: clamped),
            duration: AppDurations.slow,
            curve: AppCurves.standard,
            builder: (context, value, _) => FractionallySizedBox(
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(gradient: gradient ?? AppColors.primaryGradient),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
