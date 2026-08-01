import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/service_providers.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// No user profile/auth exists yet (out of scope for this phase), so
/// [userDisplayNameProvider] reads directly from [SharedPreferences] — it
/// will correctly return `null` today and start showing a real name the
/// moment a Profile feature writes to [AppConstants.prefsKeyUserName],
/// with zero changes needed here.
final userDisplayNameProvider = Provider<String?>((ref) {
  return ref.watch(sharedPreferencesProvider).getString(AppConstants.prefsKeyUserName);
});

class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(userDisplayNameProvider);
    final greeting = _greetingForHour(DateTime.now().hour);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name == null || name.isEmpty ? '$greeting 👋' : '$greeting,',
                style: AppTypography.bodyMediumMuted,
              ),
              if (name != null && name.isNotEmpty)
                Text(name, style: AppTypography.h1),
            ],
          ),
        ),
        name != null && name.isNotEmpty
            ? VyomAvatar(name: name, size: 44)
            : Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                child: const Icon(Icons.person_rounded, color: AppColors.mutedForeground),
              ),
      ],
    );
  }

  String _greetingForHour(int hour) {
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
