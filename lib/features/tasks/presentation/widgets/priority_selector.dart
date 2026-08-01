import 'package:flutter/material.dart';

import '../../../../core/animations/app_animations.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/models/task_priority.dart';

class PrioritySelector extends StatelessWidget {
  const PrioritySelector({required this.selected, required this.onChanged, super.key});

  final TaskPriority selected;
  final ValueChanged<TaskPriority> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TaskPriority.values.map((priority) {
        final isSelected = priority == selected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: priority == TaskPriority.values.last ? 0 : AppSpacing.sm),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: priority.label,
              child: InkWell(
                borderRadius: AppRadius.mdRadius,
                onTap: () => onChanged(priority),
                child: AnimatedContainer(
                  duration: AppDurations.fast,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected ? priority.color.withOpacity(0.16) : AppColors.surface,
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(color: isSelected ? priority.color : AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Icon(priority.icon, size: 18, color: isSelected ? priority.color : AppColors.mutedForeground),
                      const SizedBox(height: 4),
                      Text(
                        priority.label,
                        style: AppTypography.labelSmall.copyWith(
                          color: isSelected ? priority.color : AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
