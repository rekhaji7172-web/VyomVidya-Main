import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum VyomButtonVariant { primary, secondary, ghost }

/// Button family matching the V0 Design System screen: Primary (gradient
/// purple→cyan), Secondary (surface fill), Ghost (text-only). Enforces the
/// 48dp minimum touch target for accessibility.
class VyomButton extends StatelessWidget {
  const VyomButton({
    required this.label,
    required this.onPressed,
    this.variant = VyomButtonVariant.primary,
    this.icon,
    this.expand = false,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final VyomButtonVariant variant;
  final IconData? icon;
  final bool expand;
  final bool isLoading;

  bool get _disabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final child = _buildContent();

    final button = switch (variant) {
      VyomButtonVariant.primary => _PrimaryGradientButton(
          onPressed: _disabled ? null : onPressed,
          expand: expand,
          child: child,
        ),
      VyomButtonVariant.secondary => SizedBox(
          width: expand ? double.infinity : null,
          height: AppSpacing.minTouchTarget,
          child: FilledButton(
            onPressed: _disabled ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.foreground,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.pillRadius),
              side: const BorderSide(color: AppColors.border),
            ),
            child: child,
          ),
        ),
      VyomButtonVariant.ghost => SizedBox(
          height: AppSpacing.minTouchTarget,
          child: TextButton(onPressed: _disabled ? null : onPressed, child: child),
        ),
    };

    return Semantics(button: true, enabled: !_disabled, label: label, child: button);
  }

  Widget _buildContent() {
    if (isLoading) {
      return const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryForeground),
      );
    }
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        AppSpacing.gapSm,
        Text(label),
      ],
    );
  }
}

class _PrimaryGradientButton extends StatelessWidget {
  const _PrimaryGradientButton({required this.child, required this.onPressed, required this.expand});

  final Widget child;
  final VoidCallback? onPressed;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Container(
        width: expand ? double.infinity : null,
        height: AppSpacing.minTouchTarget,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppRadius.pillRadius,
          boxShadow: disabled ? null : AppShadows.primaryGlow(opacity: 0.35),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.pillRadius,
          child: InkWell(
            borderRadius: AppRadius.pillRadius,
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Center(
                child: DefaultTextStyle(
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primaryForeground),
                  child: IconTheme(
                    data: const IconThemeData(color: AppColors.primaryForeground),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating gradient FAB — used for the bottom-nav "AI" quick action.
class VyomFloatingActionButton extends StatelessWidget {
  const VyomFloatingActionButton({
    required this.icon,
    required this.onPressed,
    this.semanticLabel,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: AppShadows.primaryGlow(),
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Icon(icon, color: AppColors.primaryForeground),
          ),
        ),
      ),
    );
  }
}
