import 'package:flutter/material.dart';

import '../animations/animations.dart';
import '../constants/asset_paths.dart';
import '../theme/theme.dart';

/// The 6 tree evolution stages, matching Tree Garden's evolution path.
enum TreeStage { seed, sprout, young, growing, ancient, cosmic }

extension TreeStageX on TreeStage {
  String get label => switch (this) {
        TreeStage.seed => 'Seed',
        TreeStage.sprout => 'Sprout',
        TreeStage.young => 'Young Tree',
        TreeStage.growing => 'Growing Tree',
        TreeStage.ancient => 'Ancient Tree',
        TreeStage.cosmic => 'Cosmic Tree',
      };

  String assetFor({required bool locked}) => switch (this) {
        TreeStage.seed => locked ? AssetPaths.treeSeedLocked : AssetPaths.treeSeed,
        TreeStage.sprout => locked ? AssetPaths.treeSproutLocked : AssetPaths.treeSprout,
        TreeStage.young => locked ? AssetPaths.treeYoungLocked : AssetPaths.treeYoung,
        TreeStage.growing => locked ? AssetPaths.treeGrowingLocked : AssetPaths.treeGrowing,
        TreeStage.ancient => locked ? AssetPaths.treeAncientLocked : AssetPaths.treeAncient,
        TreeStage.cosmic => locked ? AssetPaths.treeCosmicLocked : AssetPaths.treeCosmic,
      };
}

/// Displays a tree evolution stage illustration with a gentle float
/// animation when unlocked, and a dimmed/static state when locked. Matches
/// `TreeThumb` in `primitives.tsx`. Purely presentational — no XP/water
/// data wiring yet.
class TreeThumbnail extends StatelessWidget {
  const TreeThumbnail({
    required this.stage,
    this.locked = false,
    this.size = 140,
    this.floating = true,
    super.key,
  });

  final TreeStage stage;
  final bool locked;
  final double size;
  final bool floating;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      stage.assetFor(locked: locked),
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.eco_rounded,
        size: size * 0.5,
        color: AppColors.mutedForeground,
      ),
    );

    final content = Opacity(opacity: locked ? 0.45 : 1, child: image);

    return Semantics(
      label: '${stage.label}${locked ? ', locked' : ''}',
      image: true,
      child: floating && !locked ? FloatingWidget(distance: 6, child: content) : content,
    );
  }
}
