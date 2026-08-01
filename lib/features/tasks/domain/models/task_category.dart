import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Category / color-label a task can be tagged with. Kept as a fixed enum
/// (not free-text) for Phase 2 — custom user-defined categories are a
/// natural Phase 3+ extension once there's a settings surface to manage
/// them, but a fixed set already covers real student workflows.
enum TaskCategory { study, assignment, exam, revision, personal, other }

extension TaskCategoryX on TaskCategory {
  String get label => switch (this) {
        TaskCategory.study => 'Study',
        TaskCategory.assignment => 'Assignment',
        TaskCategory.exam => 'Exam',
        TaskCategory.revision => 'Revision',
        TaskCategory.personal => 'Personal',
        TaskCategory.other => 'Other',
      };

  Color get color => switch (this) {
        TaskCategory.study => AppColors.primary,
        TaskCategory.assignment => AppColors.cyan,
        TaskCategory.exam => AppColors.destructive,
        TaskCategory.revision => AppColors.warning,
        TaskCategory.personal => AppColors.leaguePlatinum,
        TaskCategory.other => AppColors.mutedForeground,
      };

  IconData get icon => switch (this) {
        TaskCategory.study => Icons.menu_book_rounded,
        TaskCategory.assignment => Icons.assignment_rounded,
        TaskCategory.exam => Icons.school_rounded,
        TaskCategory.revision => Icons.refresh_rounded,
        TaskCategory.personal => Icons.person_rounded,
        TaskCategory.other => Icons.label_rounded,
      };
}
