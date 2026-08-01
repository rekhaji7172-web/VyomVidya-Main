import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// The 7 competitive leagues, in ascending order. Matches the rank/tier
/// colors documented in `colors.md`.
enum League { bronze, silver, gold, platinum, diamond, master, mythic }

extension LeagueX on League {
  Color get color => switch (this) {
        League.bronze => AppColors.leagueBronze,
        League.silver => AppColors.leagueSilver,
        League.gold => AppColors.leagueGold,
        League.platinum => AppColors.leaguePlatinum,
        League.diamond => AppColors.leagueDiamond,
        League.master => AppColors.leagueMaster,
        League.mythic => AppColors.leagueMythic,
      };

  String get label => switch (this) {
        League.bronze => 'Bronze',
        League.silver => 'Silver',
        League.gold => 'Gold',
        League.platinum => 'Platinum',
        League.diamond => 'Diamond',
        League.master => 'Master',
        League.mythic => 'Mythic',
      };
}

/// Metallic-tinted league badge. Matches `LeagueBadge` in `primitives.tsx`.
class LeagueBadge extends StatelessWidget {
  const LeagueBadge({required this.league, this.compact = false, super.key});

  final League league;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = league.color;

    return Semantics(
      label: '${league.label} league',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.sm : AppSpacing.md,
          vertical: compact ? AppSpacing.xs : AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.14),
          borderRadius: AppRadius.pillRadius,
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 8 : 10,
              height: compact ? 8 : 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            AppSpacing.gapXs,
            Text(
              league.label,
              style: (compact ? AppTypography.labelSmall : AppTypography.labelMedium).copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
