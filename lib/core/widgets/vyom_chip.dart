import 'package:flutter/material.dart';

import '../animations/app_animations.dart';
import '../theme/theme.dart';

/// Pill-shaped chip used for subjects, quick prompts, filters. Matches
/// `Chip` in `primitives.tsx`.
class VyomChip extends StatelessWidget {
  const VyomChip({
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
    super.key,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppCurves.standard,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget - 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary.withOpacity(0.16) : AppColors.surface,
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: selected ? AppColors.primary : AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: selected ? AppColors.primary : AppColors.mutedForeground),
            AppSpacing.gapXs,
          ],
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: selected ? AppColors.primary : AppColors.foreground,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.pillRadius,
        child: InkWell(borderRadius: AppRadius.pillRadius, onTap: onTap, child: content),
      ),
    );
  }
}
