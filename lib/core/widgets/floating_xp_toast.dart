import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../animations/app_animations.dart';
import '../theme/theme.dart';

/// Floating "+XP" popup that fades/rises and disappears — mirrors
/// `@keyframes xp-pop` / `float-up` and `FloatingXP` in `primitives.tsx`.
/// Not a data-connected widget: callers decide when/where to show it
/// (e.g. via an `Overlay` insertion once the XP feature is wired up).
class FloatingXpToast extends StatelessWidget {
  const FloatingXpToast({required this.amount, super.key});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'Plus $amount experience points earned',
      child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppRadius.pillRadius,
              boxShadow: AppShadows.primaryGlow(),
            ),
            child: Text(
              '+$amount XP',
              style: AppTypography.labelLarge.copyWith(color: AppColors.primaryForeground),
            ),
          )
          .animate()
          .fadeIn(duration: AppDurations.fast)
          .slideY(begin: 0.3, end: -0.6, duration: AppDurations.slow, curve: AppCurves.decelerate)
          .then(delay: AppDurations.fast)
          .fadeOut(duration: AppDurations.fast),
    );
  }
}
