import 'package:characters/characters.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Gradient initials avatar — used wherever a user photo isn't available.
/// Matches `InitialsAvatar` in `primitives.tsx`.
class VyomAvatar extends StatelessWidget {
  const VyomAvatar({
    required this.name,
    this.size = 44,
    this.imageUrl,
    super.key,
  });

  final String name;
  final double size;
  final String? imageUrl;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$name avatar',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          image: imageUrl != null
              ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
              : null,
        ),
        alignment: Alignment.center,
        child: imageUrl != null
            ? null
            : Text(
                _initials,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primaryForeground,
                  fontSize: size * 0.38,
                ),
              ),
      ),
    );
  }
}
