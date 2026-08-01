import 'package:flutter/material.dart';

import '../animations/app_animations.dart';

/// Thin wrapper over [AnimatedContainer] that applies VyomVidya's standard
/// duration/curve so every state-driven container animates consistently
/// without repeating the same two parameters everywhere.
class VyomAnimatedContainer extends StatelessWidget {
  const VyomAnimatedContainer({
    required this.child,
    this.decoration,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.alignment,
    this.duration = AppDurations.normal,
    this.curve = AppCurves.standard,
    super.key,
  });

  final Widget child;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      decoration: decoration,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      alignment: alignment,
      child: child,
    );
  }
}

/// Standard cross-fade + slight scale switcher for swapping between
/// loading/content/error states within the same slot, matching the
/// "smooth, purposeful" transition philosophy.
class VyomAnimatedSwitcher extends StatelessWidget {
  const VyomAnimatedSwitcher({required this.child, this.duration = AppDurations.normal, super.key});

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: AppCurves.standard,
      switchOutCurve: AppCurves.standard,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
