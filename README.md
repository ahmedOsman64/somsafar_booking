# SomSafar App

A modern travel booking and management platform built with Flutter.

---

## Table of Contents

1. [Project Description](#project-description)
2. [Technologies Used](#technologies-used)
3. [Project Requirements](#project-requirements)
4. [Project Structure](#project-structure)
5. [Features / Modules](#features--modules)
6. [Installation / Setup](#installation--setup)
7. [Usage](#usage)
8. [Contributing](#contributing)
9. [License](#license)

---

## Project Description

### What is SomSafar?

**SomSafar** is a complete travel booking platform that connects travelers with accommodation providers (hotels, apartments, and homes). The app has three different user roles, each with its own dashboard and features:

- **Travelers** - People who want to book travel services.
- **Providers** - Businesses that offer accommodation services (hotels, apartments, homes).
- **Admins** - Platform administrators who manage the entire system.

### What Problem Does It Solve?

The platform solves several problems:
- **For Travelers**: Finding and booking quality accommodation in one place is difficult.
- **For Providers**: Managing bookings, properties, and customer communication is time-consuming.
- **For Admins**: Overseeing users, properties, and finances across a platform requires powerful management tools.

SomSafar brings all of these together in one easy-to-use mobile application.

---

## Technologies Used

This project uses modern technologies to build a fast, reliable, and beautiful application. Here's what each technology does:

### Core Framework
- **Flutter** (Dart SDK 3.9.2+) - A framework by Google to build mobile, web, and desktop apps from a single codebase. We use it because it makes the app work on Android, iOS, Web, Windows, macOS, and Linux.

### Backend & Database
- **Firebase Core** (v3.15.2) - Connects the app to Google's Firebase platform.
- **Firebase Authentication** (v5.3.1) - Handles user login, signup, and security (email/password authentication).
- **Cloud Firestore** (v5.0.0) - A cloud database that stores all app data (users, bookings, services, etc.) in real-time.

### State Management
- **Flutter Riverpod** (v2.6.1) - Manages the app's state (like which user is logged in, what data to show). It keeps everything organized and reactive.
- **Riverpod** (v2.6.1) - The pure Dart version of Riverpod (used for better compatibility).

### Navigation
- **GoRouter** (v14.6.0) - Controls how users move between different screens in the app. It also handles role-based access (e.g., travelers can't access admin pages).

### UI & Design
- **Google Fonts** (v6.2.1) - Provides beautiful custom fonts for the app.
- **FL Chart** (v0.69.0) - Creates interactive charts and graphs for the dashboard (e.g., booking statistics, revenue graphs).
- **Material 3 Design** - Modern, clean, and beautiful UI components built into Flutter.

### Utilities
- **Intl** (v0.19.0) - Formats dates, times, and numbers properly (e.g., "Feb 10, 2026" or "$1,234.56").
- **UUID** (v4.5.1) - Generates unique IDs for bookings, services, etc.
- **Shared Preferences** (v2.3.2) - Saves small pieces of data locally on the device (like user settings).
- **Image Picker** (v1.1.2) - Allows users to select images from their phone gallery or camera (for profile pictures, service photos).
- **Crypto** (v3.0.7) - Provides encryption and security functions.
- **Mailer** (v6.6.0) - Sends emails (used for password reset functionality).
- **Random String** (v2.3.1) - Generates random strings (used for verification codes, etc.).
- **Cupertino Icons** (v1.0.8) - Provides iOS-style icons.

### Development Tools
- **Flutter Lints** (v5.0.0) - Checks your code for mistakes and ensures best practices.
- **Analyzer** (v10.0.2) - Analyzes Dart code for errors and warnings.
- **Flutter Test** - Built-in testing framework for writing and running tests.

---

## Project Requirements

To run this project on your computer, you need the following:

### 1. Operating System
- **Windows** (10 or 11)
- **macOS** (10.14 or later)
- **Linux** (Ubuntu 18.04 or later, or similar)

### 2. Required Software

#### Flutter SDK
- **Version**: 3.9.2 or higher
- **Download from**: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- **What it does**: The main tool to build and run Flutter apps.

#### Dart SDK
- **Version**: Comes with Flutter (3.9.2+)
- **What it does**: The programming language used by Flutter.

#### Java JDK (for Android)
- **Version**: JDK 21 (recommended) or JDK 17+
- **Download from**: [https://www.oracle.com/java/technologies/downloads/](https://www.oracle.com/java/technologies/downloads/)
- **What it does**: Required to build Android apps.
- **Important**: Set `JAVA_HOME` environment variable to the JDK folder (NOT the bin folder).

#### Android Studio (for Android development)
- **Download from**: [https://developer.android.com/studio](https://developer.android.com/studio)
- **What it does**: Provides Android SDK, emulator, and build tools.
- **What to install**: Android SDK, Android SDK Platform-Tools, Android SDK Build-Tools.

#### Xcode (for iOS/macOS development - macOS only)
- **Version**: 14.0 or later
- **Download from**: Mac App Store
- **What it does**: Required to build iOS and macOS apps.

#### Visual Studio Code OR Android Studio (Code Editor)
- **VS Code**: [https://code.visualstudio.com/](https://code.visualstudio.com/)
  - Install the **Flutter extension** and **Dart extension**.
- **Android Studio**: Already includes Flutter and Dart plugins.

#### Git (Version Control)
- **Download from**: [https://git-scm.com/](https://git-scm.com/)
- **What it does**: Manages the project code and helps with collaboration.

### 3. Firebase Account & Project
- **Create a Firebase project**: [https://console.firebase.google.com/](https://console.firebase.google.com/)
- **Enable services**:
  - Firebase Authentication (Email/Password)
  - Cloud Firestore Database
- **Download configuration files**:
  - For Android: `google-services.json` (place in `android/app/`)
  - For iOS: `GoogleService-Info.plist` (place in `ios/Runner/`)
  - For Web/other platforms: Configuration is in `lib/firebase_options.dart`

### 4. System Requirements
- **RAM**: At least 8 GB (16 GB recommended for emulators)
- **Storage**: At least 10 GB free space
- **Internet**: Required for downloading dependencies and Firebase connection

---

## Project Structure

Here's how the project files and folders are organized:

```
somsafar/
│
├── android/                  # Android-specific configuration files
│   ├── app/                  # Android app module
│   ├── gradle/               # Gradle wrapper files
│   └── build.gradle.kts      # Android build configuration
│
├── ios/                      # iOS-specific configuration files
│   ├── Runner/               # iOS app target
│   └── Podfile               # iOS dependencies
│
├── web/                      # Web-specific files
│   └── index.html            # Web app entry point
│
├── windows/                  # Windows-specific files
├── macos/                    # macOS-specific files
├── linux/                    # Linux-specific files
│
├── lib/                      # Main app code (see detailed breakdown below)
│   ├── admin/                # Admin module (admin dashboard and features)
│   ├── auth/                 # Authentication screens (login, signup, password reset)
│   ├── core/                 # Core app logic (theme, routing, services)
│   ├── provider/             # Provider module (provider dashboard and features)
│   ├── shared/               # Shared components used across all modules
│   ├── traveler/             # Traveler module (traveler dashboard and features)
│   ├── firebase_options.dart # Firebase configuration
│   └── main.dart             # App entry point
│
├── test/                     # Unit and widget tests
│
├── pubspec.yaml              # Project dependencies and configuration
├── pubspec.lock              # Locked versions of dependencies
└── README.md                 # This file!
```

### Detailed `lib/` Folder Structure

```
lib/
│
├── admin/                          # Admin Dashboard Module
│   ├── models/                     # Data models specific to admin
│   ├── screens/                    # Admin screens
│   │   ├── dashboard_screen.dart   # Admin dashboard (overview, stats)
│   │   ├── users_screen.dart       # Manage users (list all users, filter by role)
│   │   ├── create_user_screen.dart # Create new admin or provider accounts
│   │   ├── services_screen.dart    # View and manage all services
│   │   ├── financials_screen.dart  # View financial reports and transactions
│   │   ├── support_screen.dart     # Handle support tickets
│   │   └── settings_screen.dart    # App-wide settings
│   ├── widgets/                    # Reusable admin widgets
│   │   └── admin_shell.dart        # Admin navigation shell (sidebar)
│   └── admin_strings.dart          # Text constants for admin module
│
├── auth/                              # Authentication Module
│   ├── login_screen.dart              # Login page
│   ├── signup_screen.dart             # Signup page
│   ├── forgot_password_screen.dart    # Request password reset
│   ├── verification_screen.dart       # Email verification page
│   └── reset_password_screen.dart     # Set new password
│
├── core/                          # Core App Logic
│   ├── routing/                   # Navigation and routing
│   │   └── router.dart            # GoRouter configuration (all app routes)
│   ├── services/                  # Core services
│   │   └── database_service.dart  # Database initialization and setup
│   └── theme/                     # App design theme
│       └── app_theme.dart         # Colors, text styles, Material 3 theme
│
├── provider/                               # Provider Dashboard Module
│   ├── screens/                            # Provider screens
│   │   ├── provider_screens.dart           # Provider dashboard (stats, overview)
│   │   ├── services_list_screen.dart       # List of provider's services
│   │   ├── provider_service_form_screen.dart # Add/Edit service form
│   │   └── bookings_screen.dart            # Provider's booking list
│   └── widgets/                            # Reusable provider widgets
│       └── provider_shell.dart             # Provider navigation shell
│
├── shared/                        # Shared Code (used by all modules)
│   ├── models/                    # Data models
│   │   ├── user_model.dart        # User model (id, name, email, role, etc.)
│   │   ├── service_model.dart     # Service model (hotel, transport, etc.)
│   │   ├── booking_model.dart     # Booking model (dates, guests, price, etc.)
│   │   └── financial_model.dart   # Financial transaction model
│   ├── services/                  # Shared services
│   │   ├── auth_service.dart      # Authentication logic (login, logout, etc.)
│   │   ├── user_service.dart      # User CRUD operations
│   │   ├── service_service.dart   # Service CRUD operations
│   │   ├── booking_service.dart   # Booking CRUD operations
│   │   └── email_service.dart     # Email sending logic
│   ├── widgets/                   # Reusable UI components
│   └── mock_data/                 # Mock data for testing
│       └── mock_bookings.dart     # Sample booking data
│
├── traveler/                                    # Traveler Module
│   ├── screens/                                 # Traveler screens
│   │   ├── home_screen.dart                     # Home page (browse services)
│   │   ├── search_screen.dart                   # Search for services
│   │   ├── service_details_screen.dart          # View service details
│   │   ├── bookings_screen.dart                 # View traveler's bookings
│   │   ├── profile_screen.dart                  # Traveler profile and settings
│   │   ├── chat_screen.dart                     # Chat with providers
│   │   └── booking/                             # Booking flow screens
│   │       ├── booking_date_guest_screen.dart   # Select dates and guests
│   │       ├── traveler_identity_screen.dart    # Enter traveler information
│   │       ├── booking_summary_screen.dart      # Review booking before payment
│   │       ├── payment_screen.dart              # Payment screen
│   │       └── booking_success_screen.dart      # Booking confirmation
│   └── widgets/                                 # Reusable traveler widgets
│       └── traveler_shell.dart                  # Traveler navigation shell (bottom nav)
│
├── firebase_options.dart          # Auto-generated Firebase configuration
└── main.dart                      # App entry point (starts the app)
```

### What Each Folder Does (Simple Explanation)

- **`admin/`** - Everything for the admin dashboard. Admins can see all users, services, bookings, and financial reports.
- **`auth/`** - Login, signup, and password reset screens. This is where users enter the app.
- **`core/`** - The "brain" of the app. Contains routing (navigation), theme (colors and design), and core services.
- **`provider/`** - Provider dashboard where businesses manage their services and bookings.
- **`shared/`** - Code that's used by everyone (admin, provider, traveler). Contains data models, services, and reusable widgets.
- **`traveler/`** - Traveler dashboard where users can browse, search, and book services.
- **`main.dart`** - The starting point of the app. When you run the app, this file runs first.

---

## Features / Modules

### 1. **Authentication System**
- **Login**: Users can log in with email and password.
- **Signup**: New users can create accounts (as Traveler, Provider, or Admin).
- **Forgot Password**: Users can request a password reset via email.
- **Email Verification**: Users verify their email with a code.
- **Role-Based Access**: Different users see different dashboards based on their role.

### 2. **Traveler Module**
Travelers can:
- **Browse Accommodations**: View all available properties (hotels, apartments, homes).
- **Search & Filter**: Search by name, type, location, and price.
- **View Details**: See full property details (photos, description, amenities, price, reviews).
- **Book Accommodations**: Complete booking flow:
  1. Select dates and number of guests
  2. Enter traveler information
  3. Review booking summary
  4. Make payment
  5. Get booking confirmation
- **Manage Bookings**: View all their bookings (past and upcoming).
- **Chat with Providers**: Communicate with service providers.
- **Profile Management**: Update personal information and settings.

### 3. **Provider Module**
Accommodation providers can:
- **Dashboard**: View statistics (total properties, bookings, revenue).
- **Manage Properties**: Add new properties, edit existing ones, or delete listings.
- **Property Form**: Fill out detailed forms with:
  - Property name, type (hotel/apartment/home), description
  - Photos (upload from gallery)
  - Pricing, location, amenities
  - Availability calendar
- **Manage Bookings**: View all bookings for their properties.
- **Communicate**: Chat with travelers who booked their services.

### 4. **Admin Module**
Admins have different sub-roles with specific permissions:

#### **Super Admin** (Full Access)
- Access to all features.

#### **Operations Admin**
- Manage users and services.
- Handle support tickets.
- Cannot access financials or settings.

#### **Finance Admin**
- View financial reports and transactions.
- Cannot manage users, services, or settings.

#### **Support Admin**
- Handle support tickets and customer issues.
- Cannot access users, financials, or settings.

**Admin Features:**
- **Dashboard**: Overview of the entire platform (users, properties, bookings, revenue).
- **User Management**: View all users, filter by role (Admin, Provider, Traveler), create new admin/provider accounts.
- **Property Management**: View and moderate all accommodation listings on the platform.
- **Financial Reports**: View transactions, revenue, charts, and graphs.
- **Support Center**: Handle support tickets from users.
- **Settings**: Configure app-wide settings.

### 5. **Shared Features**
- **Real-time Database**: All data syncs instantly with Firebase Firestore.
- **Responsive Design**: Works beautifully on phones, tablets, and desktops.
- **Modern UI**: Material 3 design with custom fonts and colors.
- **Charts & Graphs**: Visual data representation using FL Chart.
- **Navigation**: Smooth navigation with role-based access control.

---

## Installation / Setup

Follow these steps carefully to set up the project on your computer:

### Step 1: Install Flutter

1. **Download Flutter SDK**:
   - Go to [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
   - Choose your operating system (Windows, macOS, or Linux)
   - Download the Flutter SDK package

2. **Extract the ZIP file** to a location on your computer

3. **Add Flutter to PATH**:
   - **Windows**: 
     - Search for "Environment Variables" in Windows Search
     - Click "Edit the system environment variables"
     - Click "Environment Variables"
     - Under "User variables", find "Path" and click "Edit"
     - Click "New" and add the path to `flutter\bin`
     - Click "OK" on all windows
   - **macOS/Linux**:
     - Open terminal and edit your shell profile:
       ```bash
       nano ~/.bashrc   # or ~/.zshrc for Zsh
       ```
     - Add this line:
       ```
       export PATH="$PATH:/path/to/flutter/bin"
       ```
     - Save and run: `source ~/.bashrc`

4. **Verify installation**:
   ```bash
   flutter --version
   ```
   You should see Flutter version information.

### Step 2: Install Java JDK (for Android)

1. **Download JDK**:
   - Go to [https://www.oracle.com/java/technologies/downloads/](https://www.oracle.com/java/technologies/downloads/)
   - Download JDK 17 or higher for your OS

2. **Install JDK**:
   - Run the installer
   - Remember the installation path

3. **Set JAVA_HOME environment variable**:
   - **Windows**:
     - Open Environment Variables
     - Under "System variables", click "New"
     - Variable name: `JAVA_HOME`
     - Variable value: Path to your JDK installation (NOT the bin folder!)
     - Click "OK"
   - **macOS/Linux**:
     - Add to `~/.bashrc` or `~/.zshrc`:
       ```
       export JAVA_HOME=/path/to/jdk
       ```

### Step 3: Install Android Studio (for Android development)

1. **Download Android Studio**:
   - Go to [https://developer.android.com/studio](https://developer.android.com/studio)
   - Download and install

2. **Install Android SDK**:
   - Open Android Studio
   - Go to: Tools → SDK Manager
   - Install:
     - Android SDK Platform (API 33 or higher)
     - Android SDK Build-Tools
     - Android SDK Platform-Tools
     - Android Emulator

3. **Create an Android Emulator** (optional, for testing):
   - Go to: Tools → Device Manager
   - Click "Create Device"
   - Choose a device (e.g., Pixel 4) and download a system image
   - Click "Finish"

### Step 4: Install Git

1. Download from [https://git-scm.com/](https://git-scm.com/)
2. Install with default options

### Step 5: Clone the Project

1. **Open Terminal/Command Prompt**
2. **Navigate to where you want the project**:
   ```bash
   cd /your/projects/directory
   ```

3. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/somsafar.git
   cd somsafar
   ```

### Step 6: Set Up Firebase

1. **Create a Firebase Project**:
   - Go to [https://console.firebase.google.com/](https://console.firebase.google.com/)
   - Click "Add project" and follow the steps

2. **Enable Firebase Authentication**:
   - In Firebase console, go to: Authentication → Sign-in method
   - Enable "Email/Password"

3. **Enable Cloud Firestore**:
   - Go to: Firestore Database → Create database
   - Choose "Start in test mode" (for development)
   - Select a region

4. **Add Android App to Firebase**:
   - In Firebase console, click "Add app" → Android icon
   - Package name: Find in `android/app/build.gradle`
   - Download `google-services.json`
   - Place it in `android/app/` folder

5. **Add iOS App to Firebase** (if building for iOS):
   - Click "Add app" → iOS icon
   - Bundle ID: Find in Xcode or `ios/Runner/Info.plist`
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/` folder

6. **Web/Other Platforms**:
   - Configuration is already in `lib/firebase_options.dart`
   - You may need to regenerate it with:
     ```bash
     flutterfire configure
     ```

### Step 7: Install Project Dependencies

1. **Open Terminal in the project folder**:
   ```bash
   cd /path/to/somsafar
   ```

2. **Get all Flutter packages**:
   ```bash
   flutter pub get
   ```

   This downloads all the libraries listed in `pubspec.yaml`.

### Step 8: Run Flutter Doctor

Check if everything is set up correctly:

```bash
flutter doctor
```

This command checks:
- ✓ Flutter SDK installed
- ✓ Android toolchain ready
- ✓ Connected devices available
- ✓ IDE plugins installed

Fix any issues it reports (usually just accepting Android licenses):

```bash
flutter doctor --android-licenses
```

### Step 9: Fix Common Issues

#### Issue 1: JAVA_HOME Points to bin Folder
**Error**: `JAVA_HOME is set to an invalid directory`

**Fix**:
1. Open Environment Variables
2. Edit `JAVA_HOME`
3. Ensure it points to the JDK root directory (NOT the bin folder)
4. Restart terminal

#### Issue 2: Flutter Not Found
**Error**: `'flutter' is not recognized as an internal or external command`

**Fix**:
- Make sure you added Flutter to PATH (see Step 1.3)
- Restart terminal/computer

---

## Usage

### Running the App

Once everything is installed, here's how to run the app:

### Method 1: Using Terminal/Command Prompt

1. **Open Terminal in the project folder**:
   ```bash
   cd /path/to/somsafar
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

3. **Select a device**:
   - If you have multiple devices/emulators, Flutter will ask you to choose one.
   - Example:
     ```
     [1]: Windows (desktop)
     [2]: Chrome (web)
     [3]: Pixel 4 Emulator (android)
     ```
   - Type the number and press Enter.

### Method 2: Using Visual Studio Code

1. **Open the project in VS Code**
2. **Connect a device or start an emulator**
3. **Press F5** OR click "Run" → "Start Debugging"
4. **Select device** from the bottom right corner

### Method 3: Using Android Studio

1. **Open the project in Android Studio**
2. **Select a device** from the device dropdown (top toolbar)
3. **Click the green Run button** (▶️)

### First-Time Setup

When you first run the app:

1. **App will initialize Firebase**
2. **You'll see the Login Screen**
3. **Create a new account**:
   - Click "Sign Up"
   - Choose your role: Traveler or Provider
   - Fill in your details and submit
   - Admin accounts can be created through the database directly

### Testing Different Roles

To test different user roles:

1. **Traveler**:
   - Sign up as a traveler
   - Browse services, search, book services
   - View bookings, chat with providers

2. **Provider**:
   - Sign up as a provider (or have admin create account)
   - Add services with photos, pricing
   - View bookings for your services

3. **Admin**:
   - Sign up as admin (or use default admin account)
   - Access all admin features
   - Create other admin/provider accounts

### Common Commands

```bash
# Run app (debug mode)
flutter run

# Run app (release mode, faster)
flutter run --release

# Run on specific device
flutter run -d <device-id>

# List all connected devices
flutter devices

# Clean build files (if having issues)
flutter clean
flutter pub get
flutter run

# Build APK for Android
flutter build apk

# Build iOS app
flutter build ios

# Run tests
flutter test
```

---

## Contributing

We welcome contributions! Here's how you can help:

### How to Contribute

1. **Fork the repository**
   - Click "Fork" on the repository page

2. **Clone your fork**:
   ```bash
   git clone https://github.com/your-username/somsafar.git
   cd somsafar
   ```

3. **Create a new branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make your changes**
   - Write clean, readable code
   - Follow Flutter best practices
   - Comment your code where necessary

5. **Test your changes**:
   ```bash
   flutter test
   flutter run
   ```

6. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Add: brief description of changes"
   ```

7. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Describe your changes
   - Submit!

### Coding Guidelines

- Follow Dart style guide: [https://dart.dev/guides/language/effective-dart/style](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Write comments for complex logic
- Keep functions small and focused
- Test your code before submitting

### Reporting Issues

Found a bug? Have a suggestion?

1. Go to the "Issues" tab
2. Click "New Issue"
3. Describe the problem clearly:
   - What you expected to happen
   - What actually happened
   - Steps to reproduce
   - Screenshots (if applicable)

---

## Additional Notes

### Important Files

- **`pubspec.yaml`** - Lists all dependencies. When you add a new package, add it here and run `flutter pub get`.
- **`lib/main.dart`** - The starting point of the app.
- **`lib/core/routing/router.dart`** - Controls all navigation and role-based access.
- **`lib/firebase_options.dart`** - Firebase configuration (auto-generated).
- **`android/app/google-services.json`** - Firebase config for Android (you need to add this).
- **`ios/Runner/GoogleService-Info.plist`** - Firebase config for iOS (you need to add this).

### Troubleshooting

**Problem**: Build fails with "Gradle error"
- **Solution**: Make sure `JAVA_HOME` is set correctly (see Installation step 2.3)

**Problem**: "Firebase not initialized"
- **Solution**: Make sure you added `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the correct folders.

**Problem**: App crashes on startup
- **Solution**: 
  - Check Firebase console to ensure Authentication and Firestore are enabled.
  - Run `flutter clean` and `flutter pub get`, then try again.

**Problem**: "Package not found" errors
- **Solution**: Run `flutter pub get` to download all dependencies.

---

## Contact & Support

For questions or support, please create an issue in the repository or contact the development team.

---

**Thank you for using SomSafar!** 🚀✈️🏨
