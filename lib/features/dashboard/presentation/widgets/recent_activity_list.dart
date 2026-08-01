import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/models/activity_entry.dart';
import '../providers/dashboard_providers.dart';

class RecentActivityList extends ConsumerWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(recentActivityProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Recent Activity'),
        AppSpacing.gapMd,
        activityAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: VyomSkeletonCard(),
          ),
          error: (error, stackTrace) => const SizedBox.shrink(),
          data: (entries) {
            final recent = entries.take(6).toList();
            if (recent.isEmpty) {
              return SurfaceCard(
                child: Row(
                  children: [
                    const Icon(Icons.history_rounded, color: AppColors.mutedForeground),
                    AppSpacing.gapMd,
                    Expanded(
                      child: Text(
                        'Your activity will show up here as you complete tasks.',
                        style: AppTypography.bodyMediumMuted,
                      ),
                    ),
                  ],
                ),
              );
            }
            return SurfaceCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                children: [
                  for (var i = 0; i < recent.length; i++) ...[
                    _ActivityRow(entry: recent[i]),
                    if (i != recent.length - 1)
                      const Divider(height: 1, indent: AppSpacing.lg, endIndent: AppSpacing.lg),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.entry});

  final ActivityEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
            child: Icon(entry.type.icon, size: 16, color: AppColors.primary),
          ),
          AppSpacing.gapMd,
          Expanded(
            child: Text(entry.title, style: AppTypography.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          AppSpacing.gapSm,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (entry.xpDelta > 0)
                Text('+${entry.xpDelta} XP', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
              Text(_relativeTime(entry.timestamp), style: AppTypography.labelSmall.copyWith(color: AppColors.mutedForeground)),
            ],
          ),
        ],
      ),
    );
  }

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(time);
  }
}
