import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/vyom_chip.dart';
import '../../domain/models/task_category.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({required this.selected, required this.onChanged, super.key});

  final TaskCategory selected;
  final ValueChanged<TaskCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: TaskCategory.values.map((category) {
        return VyomChip(
          label: category.label,
          icon: category.icon,
          selected: category == selected,
          onTap: () => onChanged(category),
        );
      }).toList(),
    );
  }
}
