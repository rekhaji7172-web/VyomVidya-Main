/// All feature flags recognized by the app. Add new flags here first, then
/// give them a default in [LocalFeatureFlagService] / remote-config values
/// later — never branch on a raw string key elsewhere in the codebase.
enum FeatureFlag {
  aiFeatures('ai_features_enabled'),
  premiumFeatures('premium_features_enabled'),
  communityFeatures('community_features_enabled'),
  betaFeatures('beta_features_enabled'),
  experimentalFeatures('experimental_features_enabled');

  const FeatureFlag(this.remoteKey);

  /// Key used when this flag is looked up in Firebase Remote Config
  /// (or any future remote flag backend).
  final String remoteKey;
}
