import 'package:flutter/material.dart';

import '../animations/animations.dart';
import '../theme/theme.dart';

enum AiOrbState { idle, listening, thinking }

/// VyomVidya's official visual identity (per Project Knowledge: "Never
/// replace it. Use it consistently."). Renders as a breathing, glowing
/// gradient orb. [state] drives subtle behavior differences — `thinking`
/// pulses faster to signal the AI is actively working.
///
/// This is a placeholder built entirely from gradients/blur so Phase 1 has
/// zero business/AI dependency, matching `Orb` in `primitives.tsx`. If the
/// V0 export's orb asset is a 3D/Lottie asset rather than a CSS gradient,
/// swap the painted core for that asset in a later phase without changing
/// this widget's public API.
class AiOrb extends StatelessWidget {
  const AiOrb({
    this.size = 80,
    this.state = AiOrbState.idle,
    super.key,
  });

  final double size;
  final AiOrbState state;

  @override
  Widget build(BuildContext context) {
    final glowDuration = switch (state) {
      AiOrbState.idle => AppDurations.ambientGlow,
      AiOrbState.listening => const Duration(milliseconds: 1400),
      AiOrbState.thinking => const Duration(milliseconds: 800),
    };

    final core = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [AppColors.cyan, AppColors.primary],
          center: Alignment(-0.3, -0.3),
        ),
        shape: BoxShape.circle,
      ),
    );

    return Semantics(
      label: 'VyomVidya AI assistant',
      child: PulseWidget(
        minScale: 0.96,
        maxScale: 1.04,
        duration: glowDuration,
        child: GlowWidget(
          glowColor: AppColors.primary.withOpacity(0.5),
          duration: glowDuration,
          child: core,
        ),
      ),
    );
  }
}
