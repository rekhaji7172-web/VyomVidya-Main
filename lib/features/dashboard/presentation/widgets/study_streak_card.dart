import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animations/animations.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/dashboard_providers.dart';

class StudyStreakCard extends ConsumerWidget {
  const StudyStreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(userProgressProvider).value;
    final currentStreak = progress?.currentStreak ?? 0;
    final bestStreak = progress?.bestStreak ?? 0;
    final isActive = currentStreak > 0;

    return SurfaceCard(
      semanticLabel: 'Study streak: $currentStreak days, best $bestStreak days',
      child: Row(
        children: [
          isActive
              ? PulseWidget(
                  minScale: 0.94,
                  maxScale: 1.06,
                  child: _FlameIcon(active: true),
                )
              : const _FlameIcon(active: false),
          AppSpacing.gapLg,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentStreak == 0 ? 'No active streak' : '$currentStreak day${currentStreak == 1 ? '' : 's'} streak',
                  style: AppTypography.h3,
                ),
                const SizedBox(height: 2),
                Text(
                  currentStreak == 0
                      ? 'Complete a task today to start one'
                      : 'Best: $bestStreak day${bestStreak == 1 ? '' : 's'}',
                  style: AppTypography.bodySmallMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlameIcon extends StatelessWidget {
  const _FlameIcon({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: active ? const LinearGradient(colors: [AppColors.warning, AppColors.destructive]) : null,
        color: active ? null : AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.local_fire_department_rounded,
        color: active ? AppColors.primaryForeground : AppColors.mutedForeground,
      ),
    );
  }
}
