# AetherVault

Open source local-first knowledge base for Android and Desktop.
Markdown notes, wikilinks, backlinks, and graph view.
Free and private. Your files stay on your device.

## Features

- Plain text markdown vault
- Wikilinks with [[Note Name]]
- Automatic backlinks
- Unlinked mentions
- Graph view of notes
- Daily notes
- Cross platform (Android, Windows, Linux, macOS)

## First Time Setup

```bash
git clone https://github.com/AdnanRaza88/AetherVault.git
cd AetherVault
flutter create . --project-name aether_vault
flutter pub get
```

This generates the android, windows, linux and macos folders required for building.

## Desktop

### Requirements

- Flutter 3.24 or newer
- Windows: Visual Studio with Desktop development workload
- Linux: clang, cmake, ninja, gtk development packages
- macOS: Xcode

### Run

```bash
flutter run -d windows
flutter run -d linux
flutter run -d macos
```

### Release Build

```bash
flutter build windows
flutter build linux
flutter build macos
```

Output is inside the build folder.

## Android

### Requirements

- Flutter
- Android Studio with Android SDK

### Build APK

```bash
flutter build apk --release
```

APK path: build/app/outputs/flutter-apk/app-release.apk

### Install

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## GitHub Actions

Workflow .github/workflows/build-apk.yml builds a release APK on tag push (v*) or manual trigger. Download the artifact from the Actions tab.

## Icon

App icon source is at assets/icon.svg. Replace platform icons after running flutter create.

## License

MIT
