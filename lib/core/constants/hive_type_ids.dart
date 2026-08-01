/// Central registry of Hive `typeId` values. Hive requires every
/// [TypeAdapter] to have a globally unique integer id across the *entire*
/// app — if two features each pick `0` independently, box reads silently
/// corrupt. Reserve an id here before writing a new adapter; never reuse
/// or renumber an id once shipped (it's baked into already-written boxes
/// on real devices).
abstract final class HiveTypeIds {
  static const int task = 0;
  static const int activityEntry = 1;
  static const int userProgress = 2;

  // Next available: 3

  const HiveTypeIds._();
}
