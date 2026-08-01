import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Transparent, minimal app bar used across VyomVidya screens — matches
/// the "simple, modern, minimal" navigation philosophy. Supports an
/// optional leading action (back/menu) and trailing actions (notifications,
/// avatar) without pulling in Material's default elevation/shadow.
class VyomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VyomAppBar({
    this.title,
    this.leading,
    this.actions = const [],
    this.centerTitle = false,
    super.key,
  });

  final String? title;
  final Widget? leading;
  final List<Widget> actions;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      leading: leading,
      title: title == null ? null : Text(title!, style: AppTypography.h3),
      actions: [
        ...actions,
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }
}
