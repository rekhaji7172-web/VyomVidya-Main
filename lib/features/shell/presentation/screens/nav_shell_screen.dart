import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/context_extensions.dart';
import '../../../../core/widgets/vyom_bottom_nav.dart';

/// Wraps GoRouter's [StatefulNavigationShell] with [VyomBottomNav],
/// keeping each tab's own navigation stack alive when switching tabs
/// (matches GoRouter's `StatefulShellRoute.indexedStack` behavior).
class NavShellScreen extends StatelessWidget {
  const NavShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  List<VyomNavItem> _items(BuildContext context) {
    final l10n = context.l10n;
    return [
      VyomNavItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded, label: l10n.navDashboard),
      VyomNavItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome_rounded, label: l10n.navAiAssistant),
      VyomNavItem(icon: Icons.check_circle_outline_rounded, activeIcon: Icons.check_circle_rounded, label: l10n.navTasks),
      VyomNavItem(icon: Icons.insights_outlined, activeIcon: Icons.insights_rounded, label: l10n.navProgress),
      VyomNavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: l10n.navProfile),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: VyomBottomNav(
        items: _items(context),
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          // Tapping the already-active tab pops it back to its root.
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
