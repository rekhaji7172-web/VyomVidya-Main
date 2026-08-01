import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/theme.dart';
import '../utils/context_extensions.dart';

/// Centered branded loading spinner for full-screen / section loading
/// states.
class VyomLoadingIndicator extends StatelessWidget {
  const VyomLoadingIndicator({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final label = message ?? context.l10n.commonLoading;
    return Semantics(
      liveRegion: true,
      label: label,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
            ),
            AppSpacing.gapMd,
            Text(label, style: AppTypography.bodyMediumMuted),
          ],
        ),
      ),
    );
  }
}

/// Shimmering placeholder block for skeleton loading states (card lists,
/// dashboard sections while data streams in).
class VyomSkeleton extends StatelessWidget {
  const VyomSkeleton({
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
    super.key,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: borderRadius ?? AppRadius.smRadius,
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(duration: 1200.ms, color: AppColors.hover),
    );
  }
}

/// A ready-made skeleton for card-shaped content (avatar row + two lines),
/// composed from [VyomSkeleton] — use instead of hand-rolling skeleton
/// layouts per screen.
class VyomSkeletonCard extends StatelessWidget {
  const VyomSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          VyomSkeleton(width: 120, height: 14),
          SizedBox(height: AppSpacing.sm),
          VyomSkeleton(height: 12),
          SizedBox(height: AppSpacing.xs),
          VyomSkeleton(width: 200, height: 12),
        ],
      ),
    );
  }
}
