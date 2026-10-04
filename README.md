# Road Bond

Road Bond is a Flutter mobile application for motorcycle riders to discover routes, organize group rides, connect with local riding communities, and track memorable places they have explored.

> **Status:** In active development.

---

## Features

### Implemented

- Rider-focused onboarding experience
- Age confirmation and terms agreement gate
- Rider profile setup flow
- Motorcycle licence selection
- Road Bond visual theme with dark, cream, and lime color tokens
- Rider profile dashboard
- Rider statistics:
  - Rides attended
  - Places visited
  - Kilometres travelled
- Ride-history cards with locally bundled route imagery
- Bottom navigation shell:
  - Profile
  - Community
  - Routes
- Ride discovery/search foundation
- Ride detail screen
- Custom Android and iOS launcher icons
- Local image assets packaged with Flutter

### Planned

- Community rider feed
- Group ride creation and joining
- Route search, filters, and map integration
- Rider profile editing
- Persistent local or remote data storage
- Authentication
- Ride reminders and notifications
- Location-aware ride discovery

---

## Screens

| Screen | Description |
|---|---|
| Onboarding | Introduces Road Bond, presents the rider-community message, and requires 18+ confirmation |
| Profile Setup | Collects basic rider details and motorcycle-licence status |
| Profile Dashboard | Displays rider summary, activity statistics, and discovered places |
| Discover Rides | Lists available rides and supports ride search/filtering |
| Ride Details | Shows information for a selected ride |
| Community | Reserved for rider groups, local members, and social activity |
| Routes | Reserved for route browsing and planning |

---

## Tech Stack

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- Material Design widgets
- [`google_fonts`](https://pub.dev/packages/google_fonts)
- [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons)
- Git and GitHub

---

## Project Structure

```text
lib/
├── assets/
│   └── images/
│       ├── app_logo.png
│       ├── onboarding_hero.png
│       ├── profile_hero.png
│       ├── black_spur.png
│       └── coastal_run.png
│
├── core/
│   └── theme/
│       └── app_colors.dart
│
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       └── pages/
│   │           ├── onboarding_welcome_page.dart
│   │           ├── profile_setup_page.dart
│   │           └── home_shell_page.dart
│   │
│   └── rides/
│       ├── data/
│       │   └── sample_rides.dart
│       ├── domain/
│       │   └── ride.dart
│       └── presentation/
│           ├── pages/
│           │   ├── discover_rides_page.dart
│           │   └── ride_details_page.dart
│           └── widgets/
│               └── ride_card.dart
│
└── main.dart

test/
└── widget_test.dart
```

---

## Design System

Road Bond uses a high-contrast rider-focused visual system.

| Token | Value | Usage |
|---|---:|---|
| Dark background | `#111214` | Onboarding and dark surfaces |
| Light background | `#F7F5EE` | Profile and content surfaces |
| Primary lime | `#D4FF32` | Primary calls to action and highlights |
| Dark text | `#141416` | Primary text on light backgrounds |
| Muted text | `#777E90` | Supporting copy and metadata |
| Light border | `#E2DDD1` | Inputs, dividers, and outlined elements |

Theme colors live in:

```text
lib/core/theme/app_colors.dart
```

---

## Getting Started

### Prerequisites

Install the following:

- Flutter SDK
- Dart SDK, included with Flutter
- Android Studio or VS Code
- Android Emulator, physical Android device, iOS Simulator, or physical iOS device
- Git

Check your environment:

```bash
flutter doctor
```

### Clone the Repository

```bash
git clone [https://github.com/afridmobiledev/roadbond.git](https://github.com/afridmobiledev/roadbond.git)
cd roadbond
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run
```

### Run on a Specific Device

List connected devices:

```bash
flutter devices
```

Run using a specific device ID:

```bash
flutter run -d <device-id>
```

---

## Quality Checks

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Format Dart files:

```bash
dart format lib test
```

Recommended pre-push check:

```bash
dart format lib test
flutter analyze
flutter test
```

---

## Assets

Road Bond uses local assets bundled in the application:

```text
lib/assets/images/
```

Asset registration is configured in `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true

  assets:
    - lib/assets/images/
```

After adding, deleting, or renaming an asset, perform a full rebuild:

```bash
flutter clean
flutter pub get
flutter run
```

> Hot reload does not reliably detect newly added or renamed bundled assets.

---

## Launcher Icon

The application launcher icon is generated from:

```text
lib/assets/images/app_logo.png
```

Regenerate Android and iOS launcher icons after changing that image:

```bash
dart run flutter_launcher_icons
```

Then uninstall the old app from the simulator/device and rebuild:

```bash
flutter clean
flutter pub get
flutter run
```

---

## Development Workflow

Use feature branches for new work. Avoid committing new features directly to `main`.

### Start a Feature

```bash
git checkout main
git pull origin main
git checkout -b feat/your-feature-name
```

Example:

```bash
git checkout -b feat/community-screen
```

### Validate, Commit, and Push

```bash
dart format lib test
flutter analyze
flutter test

git status
git add .
git commit -m "feat: add community screen"
git push -u origin feat/community-screen
```

After pushing, create a Pull Request on GitHub with:

```text
base branch: main
compare branch: feat/your-feature-name
```

Merge the Pull Request only after checks pass.

---

## Commit Convention

Use clear, conventional commit messages:

```text
feat: add rider profile dashboard
feat: add community screen
fix: correct onboarding asset path
refactor: extract reusable ride card
test: update onboarding widget test
chore: remove obsolete image assets
docs: update project readme
```

---

## Current Roadmap

- [x] Create Flutter project foundation
- [x] Add ride domain model and sample ride data
- [x] Build ride discovery and detail screens
- [x] Add ride search behavior
- [x] Build Road Bond onboarding UI
- [x] Build basic rider profile setup UI
- [x] Build rider profile dashboard UI
- [x] Add local road and rider image assets
- [x] Generate Android and iOS launcher icons
- [ ] Build Community screen
- [ ] Build Routes screen
- [ ] Add rider-profile editing
- [ ] Add create and join group ride flows
- [ ] Add persistent storage
- [ ] Add authentication
- [ ] Add route maps and location features
- [ ] Add end-to-end and widget-test coverage

---

## License

This project is currently private and intended for development and portfolio purposes.
