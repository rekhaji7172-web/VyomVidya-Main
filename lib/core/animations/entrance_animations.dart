import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'app_animations.dart';

/// Fades a child in on mount. Optional [delay] for staggered lists.
class FadeInWidget extends StatelessWidget {
  const FadeInWidget({
    required this.child,
    this.duration = AppDurations.normal,
    this.delay = Duration.zero,
    this.curve = AppCurves.standard,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return child.animate(delay: delay).fadeIn(duration: duration, curve: curve);
  }
}

/// Slides a child in from [begin] offset while fading it in.
class SlideInWidget extends StatelessWidget {
  const SlideInWidget({
    required this.child,
    this.begin = const Offset(0, 0.08),
    this.duration = AppDurations.normal,
    this.delay = Duration.zero,
    this.curve = AppCurves.standard,
    super.key,
  });

  final Widget child;
  final Offset begin;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: curve)
        .slide(begin: begin, end: Offset.zero, duration: duration, curve: curve);
  }
}

/// Scales a child in from [begin] scale while fading it in — used for
/// cards, chips, and reward/unlock moments.
class ScaleInWidget extends StatelessWidget {
  const ScaleInWidget({
    required this.child,
    this.begin = 0.9,
    this.duration = AppDurations.normal,
    this.delay = Duration.zero,
    this.curve = AppCurves.springOut,
    super.key,
  });

  final Widget child;
  final double begin;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: AppCurves.standard)
        .scale(
          begin: Offset(begin, begin),
          end: const Offset(1, 1),
          duration: duration,
          curve: curve,
        );
  }
}

/// Applies staggered entrance delay to each child of a list, useful for
/// task lists, subject cards, etc. Wrap items with [FadeInWidget] or
/// [SlideInWidget] and pass `delay: AppStagger.forIndex(index)`.
abstract final class AppStagger {
  static const Duration step = Duration(milliseconds: 60);

  static Duration forIndex(int index, {int maxSteps = 8}) {
    final clamped = index.clamp(0, maxSteps);
    return step * clamped;
  }

  const AppStagger._();
}
