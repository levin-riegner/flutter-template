# Store Submission Checklist

Before submitting to Google Play or the App Store, verify each item.

## Identity (blocking — needs the real product name)
- [ ] `pubspec.yaml` → name + description (currently `swiss_ai`)
- [ ] Rename package `swiss_ai` everywhere (imports, folders)
- [ ] `android/app/build.gradle` → `namespace`, `applicationId`, `applicationLabel`
  (both `qa` and `production` flavors)
- [ ] `ios/Runner/Info.plist` → `CFBundleDisplayName` / `CFBundleName`
- [ ] App icon still uses placeholder "CP" monogram — replace with final art

## Signing (blocking for release build)
- [ ] Run `./scripts/generate_release_keystore.sh` to create `android/private/release.keystore`
- [ ] Add `KEYSTORE_FILE`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`
  to GitHub Actions secrets (used by `.github/workflows/ci.yml`)

## Firebase (blocking: crashlytics, perf, remote config)
- [ ] Provide `android/app/google-services.json` (QA + Production apps)
- [ ] Provide `ios/Runner/GoogleService-Info.plist`
- [ ] `firebase_options.dart` uses placeholder key — replace with `DefaultFirebaseOptions.currentPlatform`

## Services
- [ ] Branch.io: keys in `app_routes` manifestPlaceholders still template
  (`template.app.link`). Set real domain or strip Branch.
- [ ] DataDog: set real client token + env
- [ ] On-device AI endpoints: point `ChatApiService` / `ImageGenApiService` /
  `RecordingApiService` at the real local model URLs
- [ ] Analytics/remote config wired to the real Firebase project

## Code quality
- [ ] `flutter analyze` — 0 errors (39 info-level lints remain, template debt)
- [ ] `flutter test` — 24/24 passing
- [ ] CI (`.github/workflows/ci.yml`) green: analyze → test → build APK/AAB

## Store assets
- [ ] Screenshots (phone + tablet) for the 4 supported screens
- [ ] Play feature graphic 1024x500
- [ ] App icon 1024x1024 (final, not placeholder)
- [ ] Privacy policy + data-safety form (on-device-only processing claim)
- [ ] Content rating questionnaire

## One-time
- [ ] Create Play Console project + App Store Connect project
- [ ] Add SHA256 upload cert fingerprint to Firebase Android apps
- [ ] ITC Team + Appstore App ID for iOS
