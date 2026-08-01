import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../utils/context_extensions.dart';
import 'vyom_button.dart';

/// Reusable empty-state placeholder (no tasks yet, no notes yet, etc.).
/// Falls back to generic localized copy if [title]/[message] aren't given,
/// so every feature gets a consistent, on-brand empty state for free.
class EmptyState extends StatelessWidget {
  const EmptyState({
    this.icon = Icons.inbox_rounded,
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
              child: Icon(icon, size: 32, color: AppColors.mutedForeground),
            ),
            AppSpacing.gapLg,
            Text(
              title ?? l10n.emptyStateDefaultTitle,
              style: AppTypography.h3,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapSm,
            Text(
              message ?? l10n.emptyStateDefaultMessage,
              style: AppTypography.bodyMediumMuted,
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              AppSpacing.gapXl,
              VyomButton(
                label: actionLabel ?? l10n.commonRetry,
                variant: VyomButtonVariant.secondary,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
