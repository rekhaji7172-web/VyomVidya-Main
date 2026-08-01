import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../animations/app_animations.dart';
import '../theme/theme.dart';

/// Circular progress indicator with a gradient stroke — used for the
/// Pomodoro timer ring and subject-mastery rings. Matches `ProgressRing`
/// in `primitives.tsx`.
class VyomProgressRing extends StatelessWidget {
  const VyomProgressRing({
    required this.progress,
    this.size = 200,
    this.strokeWidth = 12,
    this.gradientColors = const [AppColors.primary, AppColors.cyan],
    this.trackColor = AppColors.surface,
    this.child,
    this.semanticLabel,
    super.key,
  });

  /// 0.0–1.0. Values outside this range are clamped.
  final double progress;
  final double size;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Color trackColor;
  final Widget? child;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return Semantics(
      label: semanticLabel,
      value: '${(clamped * 100).round()}%',
      child: SizedBox(
        width: size,
        height: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: clamped),
          duration: AppDurations.slow,
          curve: AppCurves.standard,
          builder: (context, value, _) => CustomPaint(
            painter: _RingPainter(
              progress: value,
              strokeWidth: strokeWidth,
              gradientColors: gradientColors,
              trackColor: trackColor,
            ),
            child: child == null ? null : Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradientColors,
    required this.trackColor,
  });

  final double progress;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * math.pi, false, trackPaint);

    if (progress <= 0) return;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: gradientColors,
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.trackColor != trackColor;
}
