# SomSafar App

A modern travel booking platform built with Flutter, connecting travelers with accommodation providers (hotels, apartments, and homes).

---

## Table of Contents

1. [About](#about)
2. [Technologies](#technologies)
3. [Requirements](#requirements)
4. [Project Structure](#project-structure)
5. [Features](#features)
6. [Installation](#installation)
7. [Usage](#usage)
8. [Contributing](#contributing)

---

## About

### What is SomSafar?

**SomSafar** is a travel booking platform with three user roles:

- **Travelers** - Browse and book accommodation
- **Providers** - Manage properties and bookings
- **Admins** - Oversee the platform

### Key Problems Solved

- Finding quality accommodation in one place
- Managing bookings and properties efficiently
- Platform-wide oversight and analytics

---

## Technologies

### Core
- **Flutter** (Dart SDK 3.9.2+)
- **Firebase** (Core, Auth, Firestore)

### State & Navigation
- **Flutter Riverpod** (2.6.1) - State management
- **GoRouter** (14.6.0) - Navigation with role-based access

### UI & Design
- **Google Fonts** - Custom typography
- **FL Chart** - Dashboard charts and graphs
- **Material 3** - Modern design system

### Utilities
- **Intl** - Date/time formatting
- **UUID** - Unique ID generation
- **Shared Preferences** - Local storage
- **Image Picker** - Photo uploads
- **Crypto** - Encryption
- **Mailer** - Email functionality

---

## Requirements

### Software
- **Flutter SDK** 3.9.2+
- **Dart SDK** (included with Flutter)
- **Java JDK** 17+
- **Android Studio** (for Android)
- **Xcode** (for iOS/macOS - macOS only)
- **Git**

### System
- **OS**: Windows 10+, macOS 10.14+, or Linux (Ubuntu 18.04+)
- **RAM**: 8 GB minimum (16 GB recommended)
- **Storage**: 10 GB free space

### Firebase
- Firebase project with:
  - Authentication (Email/Password enabled)
  - Cloud Firestore database

---

## Project Structure

```
somsafar/
├── android/              # Android config
├── ios/                  # iOS config
├── web/                  # Web config
├── lib/                  # Main app code
│   ├── admin/            # Admin dashboard
│   │   ├── screens/      # Admin screens (8)
│   │   └── widgets/      # Admin components
│   ├── auth/             # Login, signup, password reset
│   ├── core/             # Theme, routing, services
│   ├── provider/         # Provider dashboard
│   │   ├── screens/      # Provider screens (4)
│   │   └── widgets/      # Provider components
│   ├── shared/           # Shared code
│   │   ├── models/       # Data models
│   │   ├── services/     # Business logic
│   │   └── widgets/      # Reusable UI
│   ├── traveler/         # Traveler module
│   │   ├── screens/      # Traveler screens (12)
│   │   └── widgets/      # Traveler components
│   ├── firebase_options.dart
│   └── main.dart         # App entry point
├── pubspec.yaml          # Dependencies
└── README.md
```

---

## Features

### Authentication
- Email/password login and signup
- Password reset via email
- Email verification
- Role-based access control

### Traveler Module
- Browse accommodations (hotels, apartments, homes)
- Search and filter by location, price, type
- View property details with photos
- 5-step booking flow
- Manage bookings
- Chat with providers
- Profile management

### Provider Module
- Dashboard with statistics
- Add/edit/delete properties
- Property form with photos
- Manage bookings
- Chat with travelers

### Admin Module
Four admin sub-roles with specific permissions:
- **Super Admin** - Full access
- **Operations Admin** - Users and properties
- **Finance Admin** - Financial reports only
- **Support Admin** - Support tickets only

Admin features:
- Platform overview dashboard
- User management
- Property moderation
- Financial reports with charts
- Support center
- App settings

---

## Installation

### 1. Install Flutter

```bash
# Download from https://flutter.dev/docs/get-started/install
# Extract and add to PATH
flutter --version
```

### 2. Install Java JDK

```bash
# Download JDK 17+ from https://www.oracle.com/java/technologies/downloads/
# Set JAVA_HOME environment variable
```

### 3. Install Android Studio

- Download from https://developer.android.com/studio
- Install Android SDK, Build-Tools, Platform-Tools
- Create emulator (optional)

### 4. Install Git

```bash
# Download from https://git-scm.com/
```

### 5. Clone Project

```bash
git clone https://github.com/yourusername/somsafar.git
cd somsafar
```

### 6. Set Up Firebase

1. Create Firebase project at https://console.firebase.google.com/
2. Enable Authentication (Email/Password)
3. Create Firestore database
4. Add Android app:
   - Download `google-services.json`
   - Place in `android/app/`
5. Add iOS app (if needed):
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/`

### 7. Install Dependencies

```bash
flutter pub get
```

### 8. Run Flutter Doctor

```bash
flutter doctor
```

Fix any issues, then:

```bash
flutter doctor --android-licenses
```

---

## Usage

### Running the App

```bash
# Navigate to project
cd /path/to/somsafar

# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# List devices
flutter devices
```

### Using VS Code
1. Open project
2. Select device (bottom right)
3. Press F5

### Using Android Studio
1. Open project
2. Select device (top toolbar)
3. Click Run ▶️

### First Run
1. App initializes Firebase
2. Login screen appears
3. Sign up as Traveler or Provider
4. Admin accounts created via database

### Common Commands

```bash
# Clean build
flutter clean
flutter pub get

# Build for production
flutter build apk          # Android
flutter build ios          # iOS

# Run tests
flutter test
```

---

## Contributing

### How to Contribute

1. Fork the repository
2. Create a branch: `git checkout -b feature/your-feature`
3. Make changes
4. Test thoroughly
5. Commit: `git commit -m "Add feature"`
6. Push: `git push origin feature/your-feature`
7. Create Pull Request

### Guidelines
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Write clear, commented code
- Test before submitting
- Keep functions small and focused

### Reporting Issues
- Go to Issues tab
- Click "New Issue"
- Describe problem with steps to reproduce

---

## Troubleshooting

### JAVA_HOME Error
**Error**: `JAVA_HOME is set to an invalid directory`

**Fix**: Ensure JAVA_HOME points to JDK root (not bin folder)

### Firebase Not Initialized
**Fix**: 
- Add `google-services.json` to `android/app/`
- Add `GoogleService-Info.plist` to `ios/Runner/`
- Enable Auth and Firestore in Firebase console

### Package Not Found
**Fix**: Run `flutter pub get`

### Build Fails
**Fix**: 
```bash
flutter clean
flutter pub get
flutter run
```

---

## Additional Resources

- **Flutter Documentation**: https://flutter.dev/docs
- **Firebase Documentation**: https://firebase.google.com/docs
- **Dart Language**: https://dart.dev
- **Riverpod**: https://riverpod.dev

---

**SomSafar** - Modern Travel Booking Platform 🚀✈️🏨
