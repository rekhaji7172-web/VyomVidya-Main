import 'feature_flag.dart';

/// Abstract feature-flag interface. The concrete implementation can be a
/// local hardcoded map (this phase), Firebase Remote Config (once Firebase
/// lands), or any other provider later — call sites never know which.
abstract interface class FeatureFlagService {
  /// Loads/refreshes flag values. Safe to call multiple times (e.g. on
  /// app resume). Must never throw — failures fall back to defaults.
  Future<void> initialize();

  bool isEnabled(FeatureFlag flag);
}

/// Local, hardcoded feature-flag source used until Remote Config is wired
/// up. Also serves as the guaranteed fallback if a remote fetch fails, so
/// the app never breaks due to a flag-service outage.
class LocalFeatureFlagService implements FeatureFlagService {
  final Map<FeatureFlag, bool> _defaults = {
    FeatureFlag.aiFeatures: true,
    FeatureFlag.premiumFeatures: false,
    FeatureFlag.communityFeatures: true,
    FeatureFlag.betaFeatures: false,
    FeatureFlag.experimentalFeatures: false,
  };

  @override
  Future<void> initialize() async {
    // No remote source yet — defaults above are already authoritative.
  }

  @override
  bool isEnabled(FeatureFlag flag) => _defaults[flag] ?? false;
}
