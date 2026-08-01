import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/animations/page_transitions.dart';
import '../../core/utils/context_extensions.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/shell/presentation/screens/nav_shell_screen.dart';
import '../../features/shell/presentation/screens/placeholder_screen.dart';
import '../../features/tasks/presentation/screens/planner_screen.dart';

/// Route paths as constants — never hardcode a path string at a call site
/// (`context.go(AppRoutes.dashboard)`, not `context.go('/dashboard')`).
abstract final class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String aiAssistant = '/ai';
  static const String tasks = '/tasks';
  static const String progress = '/progress';
  static const String profile = '/profile';

  /// Standalone routes reached from Dashboard Quick Actions. These features
  /// aren't built yet (out of scope for this phase) — they resolve to
  /// [PlaceholderScreen] so the quick actions are honest "coming soon"
  /// destinations instead of dead-end/broken taps.
  static const String focusSession = '/focus-session';
  static const String notes = '/notes';
  static const String flashcards = '/flashcards';

  const AppRoutes._();
}

/// Root router provider. Feature routes (onboarding, task detail, etc.)
/// are added to this config in later phases — the 5-tab shell defined here
/// is the stable backbone the rest of navigation builds on.
///
/// NOTE: no `redirect` / auth guard yet — Authentication is still out of
/// scope. That's added when Firebase Auth lands, without needing to
/// restructure these routes.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: false,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => NavShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                pageBuilder: (context, state) => AppPageTransitions.fadeThrough(
                  key: state.pageKey,
                  child: const DashboardScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.aiAssistant,
                pageBuilder: (context, state) => AppPageTransitions.fadeThrough(
                  key: state.pageKey,
                  child: PlaceholderScreen(title: context.l10n.navAiAssistant, icon: Icons.auto_awesome_rounded),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tasks,
                pageBuilder: (context, state) => AppPageTransitions.fadeThrough(
                  key: state.pageKey,
                  child: const PlannerScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                pageBuilder: (context, state) => AppPageTransitions.fadeThrough(
                  key: state.pageKey,
                  child: PlaceholderScreen(title: context.l10n.navProgress, icon: Icons.insights_rounded),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => AppPageTransitions.fadeThrough(
                  key: state.pageKey,
                  child: PlaceholderScreen(title: context.l10n.navProfile, icon: Icons.person_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.focusSession,
        pageBuilder: (context, state) => AppPageTransitions.slideUp(
          key: state.pageKey,
          child: PlaceholderScreen(title: context.l10n.quickActionFocusSession, icon: Icons.timer_rounded),
        ),
      ),
      GoRoute(
        path: AppRoutes.notes,
        pageBuilder: (context, state) => AppPageTransitions.slideUp(
          key: state.pageKey,
          child: PlaceholderScreen(title: context.l10n.quickActionNotes, icon: Icons.description_rounded),
        ),
      ),
      GoRoute(
        path: AppRoutes.flashcards,
        pageBuilder: (context, state) => AppPageTransitions.slideUp(
          key: state.pageKey,
          child: PlaceholderScreen(title: context.l10n.quickActionFlashcards, icon: Icons.style_rounded),
        ),
      ),
    ],
  );
});
