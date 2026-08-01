import 'package:flutter/material.dart';

import '../theme/theme.dart';

class VyomNavItem {
  const VyomNavItem({required this.icon, required this.activeIcon, required this.label});

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Custom bottom navigation bar matching the V0 design (dark surface,
/// gradient highlight on the active item). Purely presentational — the
/// navigation shell (GoRouter `StatefulShellRoute`) owns [currentIndex]
/// and routing on [onTap].
class VyomBottomNav extends StatelessWidget {
  const VyomBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<VyomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final selected = index == currentIndex;
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: selected,
                  label: item.label,
                  child: InkWell(
                    onTap: () => onTap(index),
                    child: SizedBox.expand(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selected ? item.activeIcon : item.icon,
                            color: selected ? AppColors.primary : AppColors.mutedForeground,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: AppTypography.labelSmall.copyWith(
                              color: selected ? AppColors.primary : AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
