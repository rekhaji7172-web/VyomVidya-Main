import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/theme/theme.dart';
import '../../../tasks/presentation/widgets/task_form_sheet.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actions = <_QuickAction>[
      _QuickAction(
        icon: Icons.timer_rounded,
        label: l10n.quickActionFocusSession,
        colors: const [AppColors.warning, AppColors.destructive],
        onTap: () => context.push(AppRoutes.focusSession),
      ),
      _QuickAction(
        icon: Icons.add_task_rounded,
        label: l10n.quickActionNewTask,
        colors: const [AppColors.primary, AppColors.cyan],
        onTap: () => showTaskFormSheet(context),
      ),
      _QuickAction(
        icon: Icons.description_rounded,
        label: l10n.quickActionNotes,
        colors: const [AppColors.cyan, AppColors.leaguePlatinum],
        onTap: () => context.push(AppRoutes.notes),
      ),
      _QuickAction(
        icon: Icons.style_rounded,
        label: l10n.quickActionFlashcards,
        colors: const [AppColors.leagueMaster, AppColors.primary],
        onTap: () => context.push(AppRoutes.flashcards),
      ),
      _QuickAction(
        icon: Icons.auto_awesome_rounded,
        label: l10n.quickActionAiAssistant,
        colors: const [AppColors.primary, AppColors.leagueMythic],
        onTap: () => context.go(AppRoutes.aiAssistant),
      ),
    ];

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => AppSpacing.gapMd,
        itemBuilder: (context, index) => actions[index],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.colors, required this.onTap});

  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        width: 88,
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.lgRadius,
          child: InkWell(
            borderRadius: AppRadius.lgRadius,
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: AppRadius.lgRadius,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.primaryForeground, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: AppTypography.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
