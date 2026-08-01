import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../utils/context_extensions.dart';

/// Standard "Section Title  ·  See all" header used above lists/carousels
/// throughout the dashboard, progress, and other data-heavy screens.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.onSeeAll,
    this.trailing,
    super.key,
  });

  final String title;
  final VoidCallback? onSeeAll;

  /// Custom trailing widget; ignored if [onSeeAll] is also provided.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTypography.h3)),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              context.l10n.commonSeeAll,
              style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
            ),
          )
        else if (trailing != null)
          trailing!,
      ],
    );
  }
}
