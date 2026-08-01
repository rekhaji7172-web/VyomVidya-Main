import 'package:flutter/widgets.dart';

import 'app_animations.dart';

/// Gentle up/down floating loop — mirrors the `@keyframes float` /
/// `float-up` used for tree art, the AI orb, and sprout illustrations.
class FloatingWidget extends StatefulWidget {
  const FloatingWidget({
    required this.child,
    this.distance = 8,
    this.duration = AppDurations.ambientFloat,
    super.key,
  });

  final Widget child;
  final double distance;
  final Duration duration;

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  late final Animation<double> _offset = Tween<double>(
    begin: -widget.distance / 2,
    end: widget.distance / 2,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _offset.value),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Breathing scale pulse — mirrors `@keyframes breathing-scale` /
/// `pulseGlow`. Used on the AI Orb idle state and streak flame icon.
class PulseWidget extends StatefulWidget {
  const PulseWidget({
    required this.child,
    this.minScale = 0.97,
    this.maxScale = 1.03,
    this.duration = AppDurations.ambientPulse,
    super.key,
  });

  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;

  @override
  State<PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(
    begin: widget.minScale,
    end: widget.maxScale,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
      child: widget.child,
    );
  }
}

/// Glow intensity pulse — animates a [BoxShadow] blur/opacity in a loop.
/// Mirrors `@keyframes glow-pulse` / `breathe-glow`, used behind the Orb
/// and primary gradient CTAs.
class GlowWidget extends StatefulWidget {
  const GlowWidget({
    required this.child,
    required this.glowColor,
    this.minBlur = 16,
    this.maxBlur = 34,
    this.duration = AppDurations.ambientGlow,
    this.borderRadius,
    super.key,
  });

  final Widget child;
  final Color glowColor;
  final double minBlur;
  final double maxBlur;
  final Duration duration;
  final BorderRadius? borderRadius;

  @override
  State<GlowWidget> createState() => _GlowWidgetState();
}

class _GlowWidgetState extends State<GlowWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  late final Animation<double> _blur = Tween<double>(
    begin: widget.minBlur,
    end: widget.maxBlur,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blur,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: [
            BoxShadow(
              color: widget.glowColor,
              blurRadius: _blur.value,
              spreadRadius: _blur.value / 8,
            ),
          ],
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}
