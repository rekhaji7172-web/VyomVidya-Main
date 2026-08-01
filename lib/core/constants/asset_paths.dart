/// Centralized asset paths. Never hardcode `'assets/images/...'` strings in
/// widgets — reference this file so a renamed/moved asset only needs one
/// update.
abstract final class AssetPaths {
  static const String _images = 'assets/images';
  static const String _tree = '$_images/tree';
  static const String _onboarding = '$_images/onboarding';
  static const String _categories = '$_images/categories';
  static const String _preferences = '$_images/preferences';

  // ---- Brand ----
  static const String orb = '$_images/orb.png';

  // ---- Onboarding ----
  static const String heroSprout = '$_onboarding/hero-sprout.png';

  // ---- Tree Garden evolution stages ----
  static const String treeSeed = '$_tree/seed.png';
  static const String treeSeedLocked = '$_tree/seed-locked.png';
  static const String treeSprout = '$_tree/sprout.png';
  static const String treeSproutLocked = '$_tree/sprout-locked.png';
  static const String treeYoung = '$_tree/young-tree.png';
  static const String treeYoungClean = '$_tree/young-tree-clean.png';
  static const String treeYoungLocked = '$_tree/young-tree-locked.png';
  static const String treeGrowing = '$_tree/growing-tree.png';
  static const String treeGrowingClean = '$_tree/growing-tree-clean.png';
  static const String treeGrowingLocked = '$_tree/growing-tree-locked.png';
  static const String treeAncient = '$_tree/ancient-tree.png';
  static const String treeAncientClean = '$_tree/ancient-tree-clean.png';
  static const String treeAncientLocked = '$_tree/ancient-tree-locked.png';
  static const String treeCrystal = '$_tree/crystal-tree.png';
  static const String treeCosmic = '$_tree/cosmic-tree.png';
  static const String treeCosmicGlow = '$_tree/cosmic-tree-glow.png';
  static const String treeCosmicLocked = '$_tree/cosmic-tree-locked.png';
  static const String treeWorld = '$_tree/world-tree.png';
  static const String treeWorldGlow = '$_tree/world-tree-glow.png';
  static const String treeWorldLocked = '$_tree/world-tree-locked.png';

  // ---- Onboarding goal categories ----
  static const String categoryCollege = '$_categories/college.png';
  static const String categoryCompetitiveExams = '$_categories/competitive-exams.png';
  static const String categoryGovernmentExams = '$_categories/government-exams.png';
  static const String categoryLanguageLearning = '$_categories/language-learning.png';
  static const String categoryOther = '$_categories/other.png';
  static const String categoryProfessionalCerts = '$_categories/professional-certs.png';
  static const String categorySchoolExams = '$_categories/school-exams.png';
  static const String categorySkillDevelopment = '$_categories/skill-development.png';

  // ---- Learning preference styles ----
  static const String preferenceAuditory = '$_preferences/auditory-style.png';
  static const String preferenceHandsOn = '$_preferences/handson-style.png';
  static const String preferenceReading = '$_preferences/reading-style.png';
  static const String preferenceVisual = '$_preferences/visual-style.png';

  const AssetPaths._();
}
