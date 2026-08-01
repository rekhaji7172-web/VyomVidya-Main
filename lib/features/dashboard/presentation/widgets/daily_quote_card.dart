import 'package:flutter/material.dart';

import '../../../../core/animations/animations.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/models/quote.dart';

class DailyQuoteCard extends StatelessWidget {
  const DailyQuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final quote = DailyQuotes.today;

    return FadeInWidget(
      child: GlassCard(
        semanticLabel: 'Daily quote',
        tint: AppColors.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.format_quote_rounded, color: AppColors.primary.withOpacity(0.7), size: 28),
            AppSpacing.gapSm,
            Text(
              quote.text,
              style: AppTypography.bodyLarge.copyWith(fontStyle: FontStyle.italic, height: 1.4),
            ),
            AppSpacing.gapSm,
            Text('— ${quote.author}', style: AppTypography.labelMedium.copyWith(color: AppColors.mutedForeground)),
          ],
        ),
      ),
    );
  }
}
