import 'package:flutter/material.dart';

import '../animations/animations.dart';
import '../theme/theme.dart';

/// Reward chest visual — closed state pulses gently to invite a tap; open
/// state is driven by [isOpen]. Purely presentational; the unlock/open
/// business logic and treasure-burst confetti are wired up when the XP
/// Shop feature is built. Matches `RewardChest` in `primitives.tsx`.
class RewardChest extends StatelessWidget {
  const RewardChest({
    required this.isOpen,
    this.size = 96,
    this.onTap,
    super.key,
  });

  final bool isOpen;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      isOpen ? Icons.card_giftcard_rounded : Icons.inventory_2_rounded,
      size: size * 0.5,
      color: isOpen ? AppColors.warning : AppColors.mutedForeground,
    );

    final chest = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: isOpen
            ? const LinearGradient(colors: [AppColors.warning, AppColors.leagueGold])
            : null,
        color: isOpen ? null : AppColors.surface,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(color: isOpen ? AppColors.warning : AppColors.border),
      ),
      alignment: Alignment.center,
      child: icon,
    );

    final animated = isOpen ? chest : PulseWidget(minScale: 0.98, maxScale: 1.02, child: chest);

    return Semantics(
      button: onTap != null,
      label: isOpen ? 'Reward chest, open' : 'Reward chest, tap to open',
      child: onTap == null
          ? animated
          : GestureDetector(onTap: onTap, child: animated),
    );
  }
}
