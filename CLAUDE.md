# ClipKitty Sparkle Test

## Mission
Debug and fix the Sparkle auto-update implementation so that a running instance of ClipKittyTest
detects, downloads, and installs an update from the appcast. Iterate until confirmed working.

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
make build         # Compile app (Debug config)
make build CONFIGURATION=Release  # Compile app (Release config)
make run           # Build and launch
```

## Key Files
- `Project.swift` — Tuist manifest, version numbers, Info.plist keys (SUFeedURL, SUPublicEDKey)
- `Sources/App/UpdateController.swift` — Sparkle integration, SilentUpdateDriver
- `Sources/App/ClipKitty.oss.entitlements` — entitlements (sandbox, XPC, network)
- `.github/workflows/build.yml` — CI pipeline
- `distribution/generate-appcast.sh` — appcast XML generator
- `distribution/build-dmg.sh` — DMG creation

## Debugging History
Versions 1.0.1–1.0.6 attempted fixes: disabled InstallerLauncherService, added print debugging,
disabled sandbox, but updates still not installing.
