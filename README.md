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
- Templates
- Cross platform (Android, Windows, Linux, macOS)

## Desktop Setup

### Requirements

- Flutter 3.24 or newer
- For Windows: Visual Studio with Desktop development
- For Linux: required system libraries
- For macOS: Xcode

### Build and Run

```bash
git clone https://github.com/AdnanRaza88/AetherVault.git
cd AetherVault
flutter pub get
flutter run -d windows
# or
flutter run -d linux
# or
flutter run -d macos
```

### Release Build

```bash
flutter build windows
flutter build linux
flutter build macos
```

The output will be in the build folder.

## Android Setup

### Requirements

- Flutter
- Android Studio
- Android SDK

### Build APK

```bash
flutter build apk --release
```

APK location: build/app/outputs/flutter-apk/app-release.apk

### Install on device

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## GitHub Actions

The repository includes workflows to build Android APK and desktop packages on every release tag.

## Project Structure

```
lib/
  main.dart
  models/
    note.dart
  services/
    vault_service.dart
  screens/
    home_screen.dart
    note_editor.dart
    graph_view.dart
  widgets/
    sidebar.dart
    backlinks_panel.dart
    wikilink_text.dart
```

## License

MIT
