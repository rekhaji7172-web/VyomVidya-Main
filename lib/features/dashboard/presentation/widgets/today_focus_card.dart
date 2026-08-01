import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/dashboard_providers.dart';

class TodayFocusCard extends ConsumerWidget {
  const TodayFocusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(todaysFocusStatsProvider);
    final completionRatio = stats.totalTasksToday == 0 ? 0.0 : stats.completedTasksToday / stats.totalTasksToday;

    return GlassCard(
      semanticLabel: "Today's focus summary",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Today's Focus", style: AppTypography.h3),
              const Spacer(),
              Text(
                '${stats.completedTasksToday}/${stats.totalTasksToday} done',
                style: AppTypography.labelMedium.copyWith(color: AppColors.mutedForeground),
              ),
            ],
          ),
          AppSpacing.gapMd,
          VyomProgressBar(progress: completionRatio, semanticLabel: "Today's task completion"),
          AppSpacing.gapXl,
          Row(
            children: [
              Expanded(
                child: _StatBlock(
                  icon: Icons.checklist_rounded,
                  value: '${stats.totalTasksToday}',
                  label: 'Tasks',
                  color: AppColors.cyan,
                ),
              ),
              Expanded(
                child: _StatBlock(
                  icon: Icons.check_circle_rounded,
                  value: '${stats.completedTasksToday}',
                  label: 'Done',
                  color: AppColors.success,
                ),
              ),
              Expanded(
                child: _StatBlock(
                  icon: Icons.timer_rounded,
                  value: '${stats.focusMinutesToday}m',
                  label: 'Focus',
                  color: AppColors.warning,
                ),
              ),
              Expanded(
                child: _StatBlock(
                  icon: Icons.bolt_rounded,
                  value: '+${stats.xpEarnedToday}',
                  label: 'XP',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.icon, required this.value, required this.label, required this.color});

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: color.withOpacity(0.14), shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 8),
        Text(value, style: AppTypography.monoMedium),
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.mutedForeground)),
      ],
    );
  }
}
