# FINAL_PREBUILD_CHECKLIST.md
### VyomVidya V2 — Pre-GitHub-Push Consistency Audit

Scope: full cross-check of `pubspec.yaml` ↔ `android/` ↔ `codemagic.yaml`
requested before the first push. Three real bugs were found and fixed
during this audit (marked 🔧 below) — this is not just a report, the repo
in this delivery already has them corrected.

---

## 🔧 Bugs found and fixed in this audit

1. **`kotlinOptions.jvmTarget` type mismatch** (`android/app/build.gradle`).
   Was `jvmTarget = JavaVersion.VERSION_17` — that property expects a
   `String`, not Gradle's `JavaVersion` enum object directly. Groovy may or
   may not silently coerce this depending on the exact Kotlin Gradle
   plugin version, so it was a real risk of a hard Gradle configuration
   error. Fixed to `jvmTarget = JavaVersion.VERSION_17.toString()`,
   matching current official Flutter templates.

2. **Gradle-wrapper bootstrap ran before `local.properties` existed**
   (`codemagic.yaml`). The old step order ran `gradle wrapper` first, then
   `flutter pub get`. But `android/settings.gradle`'s `pluginManagement`
   block reads `local.properties` to find the Flutter SDK path — and that
   file is only written by `flutter pub get`, not present on a fresh
   clone. On a clean checkout this would have failed the *first* script
   with a file-not-found error before Gradle could even configure the
   project. Fixed: `flutter pub get` now runs first.

3. **`android_signing: [vyomvidya_keystore]` referenced a signing group
   that doesn't exist yet** in the Codemagic dashboard. Codemagic
   validates referenced signing groups before running any build script —
   an unconfigured reference fails the build immediately, before your code
   is even touched. Commented out with instructions to re-enable once the
   group is actually created; release builds fall back to debug signing
   in the meantime (matches the existing `NOTE:` in `app/build.gradle`).

---

## ✅ Verified Consistent

| Check | Result |
|---|---|
| `applicationId` (`app/build.gradle`) | `com.vyomvidya.app` |
| `namespace` (`app/build.gradle`) | `com.vyomvidya.app` — matches applicationId |
| Kotlin `package` (`MainActivity.kt`) | `com.vyomvidya.app` |
| Kotlin file path | `android/app/src/main/kotlin/com/vyomvidya/app/MainActivity.kt` — physically matches its own package declaration |
| `AndroidManifest.xml` | No `package` attribute (correct for AGP 8.x — identity comes from `namespace` in `build.gradle`, not the manifest) |
| Flutter embedding | `MainActivity` extends `io.flutter.embedding.android.FlutterActivity` (v2 class) **and** manifest declares `<meta-data android:name="flutterEmbedding" android:value="2" />` — both agree |
| `minSdkVersion` | `21`, hardcoded (not `flutter.minSdkVersion`) — compatible with every plugin in `pubspec.yaml` (`connectivity_plus`, `shared_preferences`, `hive_flutter` all support 21+) |
| `compileSdk` / `targetSdk` | `flutter.compileSdkVersion` / `flutter.targetSdkVersion` — auto-resolved from whatever Flutter SDK Codemagic uses, not hand-pinned, so they can't drift out of sync with the SDK itself |
| Gradle plugin versions | AGP `8.3.0`, Kotlin `1.9.22`, Gradle `8.4` — a known-compatible triplet as of my training data |
| `pubspec.yaml` deps → Android manifest permissions | `connectivity_plus` needs `ACCESS_NETWORK_STATE` (present); `google_fonts` fetches fonts at runtime and needs `INTERNET` (present) — both covered by the same 2 permissions already declared |
| `codemagic.yaml` step chain | `pub get` → `gradle wrapper` bootstrap → `analyze` → `build apk` → `build appbundle`, each step's precondition satisfied by the one before it |
| Old "Vibe" references | Zero, across the entire repo (re-confirmed this audit) |

---

## ⚠ Remaining Assumptions (things I cannot verify without a real build)

These are not known bugs — they're exactly the kind of "could cause the
first build to fail" items you asked me to surface, because I have no
Flutter/Gradle/Codemagic environment to actually test against.

1. **`intl` version.** `flutter_localizations` (bundled with the Flutter
   SDK) pins an *exact* `intl` version tied to whatever Flutter release
   Codemagic's `flutter: stable` resolves to at build time — and that pin
   has changed across Flutter releases before. I changed `pubspec.yaml`'s
   `intl: ^0.19.0` to `intl: any` during this audit specifically to
   eliminate this risk (lets pub resolve the exact version transitively
   instead of guessing a range). This is the single most likely
   remaining source of a `flutter pub get` version-solving failure if it
   happens anyway for an unrelated package.
2. **`flutter: stable` is a moving target.** It gives you whatever is
   current on Codemagic's stable channel the day you build, which is
   simple but not perfectly reproducible build-to-build. If you want
   fully pinned, reproducible builds later, tell me and I'll change it to
   an exact version (e.g. `flutter: 3.24.0`) once we know what Codemagic
   has available.
3. **Codemagic's default image has `gradle` on `PATH`.** The wrapper
   bootstrap step assumes this (standard on Codemagic's default Flutter
   build images). If you've selected a custom/minimal build machine type
   in Codemagic, this step could fail with "gradle: command not found."
4. **JDK 17 availability.** `compileOptions`/`kotlinOptions` target Java
   17, matching AGP 8.3.0's requirement. Standard on current Codemagic
   images; would only be a problem on an old/pinned machine image.
5. **`build/app/outputs/**/mapping.txt` artifact glob** will simply match
   nothing (harmless) since `minifyEnabled` isn't turned on — included for
   when you enable R8/ProGuard later, not a current risk.
6. **Debug-signed release APK/AAB.** Confirmed intentional (see bug #3
   above) — flagging again here because it's the one that determines
   whether the build is "APK works" vs "AAB is Play-Store-uploadable."

---

## 🚀 Net Assessment

With the 3 fixes above applied, I have no further static-analysis-visible
reason to expect the first Codemagic build to fail. The `intl` and
`flutter: stable` items are inherent to not having a real SDK to resolve
against — if the first build fails on either, send me the exact log line
and I can fix it from that alone, no local reproduction needed on your
end.

**Recommended first build:** run the `vyomvidya-android` workflow as-is
(signing/publishing blocks intentionally commented out) to get a
debug-signed test APK before worrying about Play Store signing.
