import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/dashboard_providers.dart';

class XpSummaryCard extends ConsumerWidget {
  const XpSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xp = ref.watch(xpDisplayProvider);

    return GlassCard(
      semanticLabel: 'Level ${xp.level}, ${xp.xpIntoLevel} of ${xp.xpForNextLevel} experience points',
      child: Row(
        children: [
          VyomProgressRing(
            progress: xp.progress,
            size: 88,
            strokeWidth: 8,
            semanticLabel: 'Progress to next level',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${xp.level}', style: AppTypography.h2),
                Text('LEVEL', style: AppTypography.labelSmall.copyWith(color: AppColors.mutedForeground)),
              ],
            ),
          ),
          AppSpacing.gapLg,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LeagueBadge(league: xp.league),
                AppSpacing.gapSm,
                Text(
                  '${xp.xpIntoLevel} / ${xp.xpForNextLevel} XP',
                  style: AppTypography.monoSmall.copyWith(color: AppColors.mutedForeground),
                ),
                const SizedBox(height: 4),
                Text('${xp.totalXp} total XP earned', style: AppTypography.bodySmallMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
