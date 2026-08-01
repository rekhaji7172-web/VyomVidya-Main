import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/widgets/widgets.dart';

/// Temporary placeholder for a shell tab, shown until its real feature is
/// built in a later phase. Deliberately uses the same design tokens as
/// every other screen so Phase 1 already "feels" like VyomVidya.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, required this.icon, super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VyomAppBar(title: title),
      body: EmptyState(
        icon: icon,
        title: title,
        message: context.l10n.commonComingSoon,
      ),
    );
  }
}
