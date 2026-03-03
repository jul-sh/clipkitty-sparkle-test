# ClipKitty Sparkle Test

## Architecture
- macOS menu bar app (Swift 6.2 + Rust backend via UniFFI)
- Sparkle 2.9.0 for auto-updates (non-App Store builds)
- Build system: Tuist (project gen) → xcodebuild (compile) → codesign → DMG → notarize
- CI: GitHub Actions on `release` branch → builds, signs, notarizes, generates appcast, deploys to gh-pages
- Appcast URL: https://jul-sh.github.io/clipkitty-sparkle-test/appcast.xml
- Releases: https://github.com/jul-sh/clipkitty-sparkle-test/releases

## Build Commands
```bash
make rust          # Build Rust library (libpurr.a)
make generate      # Generate Xcode project via Tuist
make build         # Compile app (Release config, default)
make run           # Build and launch
```

## Key Files
- `Project.swift` — Tuist manifest, version numbers, Info.plist keys (SUFeedURL, SUPublicEDKey)
- `Sources/App/UpdateController.swift` — Sparkle integration, SilentUpdateDriver
- `Sources/App/ClipKitty.oss.entitlements` — entitlements (sandbox disabled for Sparkle)
- `.github/workflows/build.yml` — CI pipeline
- `distribution/generate-appcast.sh` — appcast XML generator
- `distribution/build-dmg.sh` — DMG creation

## Sparkle Update Mechanism (VERIFIED WORKING)
- **Status**: Fully working as of v1.0.7
- **Flow**: App checks appcast → detects newer version → downloads DMG → extracts → replaces app → relaunches
- **Version comparison**: Sparkle compares `CFBundleVersion` against `sparkle:version` in appcast
- **Startup check**: UpdateController triggers `checkForUpdates()` 5 seconds after launch to ensure prompt detection

## Fixes Applied (v1.0.7)
1. **CFBundleVersion/sparkle:version alignment** — Makefile now defaults BUILD_NUMBER to VERSION
   so CFBundleVersion matches sparkle:version. Previously BUILD_NUMBER used git commit count,
   causing version comparison mismatches.
2. **Startup update check** — Added explicit `checkForUpdates()` call 5s after launch.
   Sparkle's automatic scheduler has timing constraints on first launch that could delay detection.
3. **Sandbox disabled** — Non-App Store builds have sandbox disabled so Sparkle can replace the app bundle.
4. **InstallerLauncherService disabled** — Not needed without sandbox.

## Known Issues
- `Sync Version to Main` CI step fails (ADMIN_TOKEN permissions). Manually bump version in Project.swift.
- `print()` output is fully buffered for macOS apps run in background; use `NSLog()` for debugging.
