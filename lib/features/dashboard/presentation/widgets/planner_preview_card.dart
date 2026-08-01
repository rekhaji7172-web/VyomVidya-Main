import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../tasks/presentation/providers/task_actions_controller.dart';
import '../../../tasks/presentation/providers/task_providers.dart';
import '../../../tasks/presentation/widgets/task_tile.dart';

class PlannerPreviewCard extends ConsumerWidget {
  const PlannerPreviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayTasks = ref.watch(todayTasksProvider);
    final preview = todayTasks.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Today's Planner",
          onSeeAll: () => context.go(AppRoutes.tasks),
        ),
        AppSpacing.gapMd,
        if (preview.isEmpty)
          SurfaceCard(
            onTap: () => context.go(AppRoutes.tasks),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny_outlined, color: AppColors.mutedForeground),
                AppSpacing.gapMd,
                Expanded(
                  child: Text(
                    'Nothing due today — tap to plan your day.',
                    style: AppTypography.bodyMediumMuted,
                  ),
                ),
              ],
            ),
          )
        else
          ...preview.map(
            (task) => TaskTile(
              task: task,
              onToggleComplete: () => ref.read(taskActionsControllerProvider).toggleComplete(task),
              onTap: () => context.go(AppRoutes.tasks),
              onDelete: () => ref.read(taskActionsControllerProvider).deleteTask(task.localId),
            ),
          ),
      ],
    );
  }
}
