import 'package:flutter/material.dart';

import '../error/failure.dart';
import '../theme/theme.dart';
import '../utils/context_extensions.dart';
import 'vyom_button.dart';

/// Reusable error placeholder shown when a `Result` comes back as
/// [ResultError]. Distinguishes the offline case (from [NetworkFailure])
/// with different copy/icon, since that's the most common and most
/// actionable failure in an offline-first app.
class ErrorState extends StatelessWidget {
  const ErrorState({
    this.failure,
    this.onRetry,
    super.key,
  });

  final Failure? failure;
  final VoidCallback? onRetry;

  bool get _isOffline => failure is NetworkFailure;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = _isOffline ? l10n.errorNoInternetTitle : l10n.errorGenericTitle;
    final message = failure?.message ?? (_isOffline ? l10n.errorNoInternetMessage : l10n.errorGenericMessage);

    return Semantics(
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.destructive.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isOffline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
                  size: 32,
                  color: AppColors.destructive,
                ),
              ),
              AppSpacing.gapLg,
              Text(title, style: AppTypography.h3, textAlign: TextAlign.center),
              AppSpacing.gapSm,
              Text(message, style: AppTypography.bodyMediumMuted, textAlign: TextAlign.center),
              if (onRetry != null) ...[
                AppSpacing.gapXl,
                VyomButton(label: l10n.commonRetry, onPressed: onRetry),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
