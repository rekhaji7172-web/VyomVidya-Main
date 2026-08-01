# VyomVidya V2

Production Flutter app: Clean Architecture + Riverpod + GoRouter, offline-first
(Hive), localization-ready, analytics/monitoring interfaces, feature flags,
dependency inversion. Built phone-only: **Phone → Claude → GitHub → Codemagic
Cloud Build → APK/AAB.** There is no local Flutter SDK anywhere in this
workflow — everything below runs in Codemagic, not on your device.

## What's in this repo

- `lib/` — Phase 1 (foundation) + Phase 2 (Dashboard + Planner), Clean
  Architecture, hand-written models/Hive adapters (see note below)
- `android/` — hand-authored Flutter Android wrapper (this step)
- `assets/` — V0-derived design assets
- `pubspec.yaml`, `analysis_options.yaml`, `l10n.yaml` — project config
- `codemagic.yaml` — the CI/CD pipeline that builds the APK/AAB in the cloud
- `VALIDATION_REPORT.md` — static validation report from the last phase

## Android wrapper — what to know before your first Codemagic build

1. **Package/application id:** `com.vyomvidya.app` (set in
   `android/app/build.gradle` and `MainActivity.kt`). If you already
   registered a different id on Play Console, this must match it exactly —
   tell me and I'll update both places consistently.
2. **`gradle-wrapper.jar` is intentionally not committed.** It's a binary
   file that can't be hand-authored outside a real Gradle environment.
   `codemagic.yaml`'s first build step (`gradle wrapper --gradle-version
   8.4 --distribution-type all`) regenerates it — and `gradlew`/
   `gradlew.bat` — fresh on every build, using Gradle already installed on
   the Codemagic image. Nothing else in `android/` is touched by that step.
3. **App icon** is a generated placeholder (brand gradient + "V" mark) at
   all 5 mipmap densities — on-brand, but a simple programmatic mark, not
   final polished artwork. Swap the PNGs at
   `android/app/src/main/res/mipmap-*/ic_launcher.png` any time; nothing
   else needs to change.
4. **Release signing** currently falls back to the debug keystore (see the
   `NOTE:` in `android/app/build.gradle`) — fine for internal APK testing,
   **not** for a Play Store submission. Before publishing, set up a
   `vyomvidya_keystore` signing group in the Codemagic dashboard (referenced
   in `codemagic.yaml`) with your real upload keystore.
5. **iOS/web wrappers were deliberately not built this step** — your stated
   pipeline only outputs APK/AAB. Ask any time and I'll add `ios/` the same
   way (hand-authored where possible; Xcode's `project.pbxproj` has enough
   structural complexity that I'd flag it for extra scrutiny before trusting
   a first build).

## Code generation note

`freezed`, `json_serializable`, and `riverpod_generator` are in
`pubspec.yaml` but unused so far — Phase 1/2 domain models are hand-written
specifically so the app compiles with just `flutter pub get`, no
`build_runner` step, no local SDK needed to verify. The day a feature
actually adds a `@freezed`/`json_serializable` model, add a
`dart run build_runner build --delete-conflicting-outputs` step to
`codemagic.yaml` right after "Flutter pub get".

## Workflow reminder

Every future phase continues from this exact codebase. No phase gets
regenerated from scratch, and no other tool/AI should recreate this project
— GitHub push → Codemagic build is the only build path.
