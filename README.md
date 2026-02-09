# SomSafar Booking App 🌍

Welcome to **SomSafar**, a modern and comprehensive travel booking platform built with Flutter. Whether you want to book a hotel, list your own apartment, or manage the entire platform as an admin, SomSafar provides a seamless experience for everyone.

---

## 📝 Project Description

**SomSafar** is a multi-role booking application designed to simplify the process of finding and managing travel services. It solves the problem of disconnected booking systems by bringing three types of users into one platform:

1.  **Travelers**: People looking for places to stay (Hotels, Homes, Apartments) or transportation.
2.  **Providers**: Business owners who want to list their properties or services.
3.  **Admins**: Managers who oversee all users, services, and financial reports.

The app provides real-time booking, secure authentication, and beautiful dashboards to track progress and stats.

---

## 🚀 Technologies Used

We use the latest tools and frameworks to ensure the app is fast, secure, and easy to maintain:

| Technology | Purpose |
| :--- | :--- |
| **Flutter & Dart** | The main framework used to build the app for both Android and iOS. |
| **Firebase Auth** | Handles secure user login, registration, and password resets. |
| **Cloud Firestore** | A real-time database used to store all bookings, services, and user data. |
| **Riverpod** | Manages the "state" of the app (e.g., keeping track of who is logged in). |
| **GoRouter** | Handles navigation between different screens smoothly. |
| **fl_chart** | Used to create beautiful charts and graphs for the Admin dashboard. |
| **Google Fonts** | Provides clean and modern typography (fonts) for the app. |

---

## 📋 Project Requirements

To run this project on your own computer, you will need:

### 1. Software & Tools
*   **Flutter SDK**: The latest version of Flutter (v3.9 or higher is recommended).
*   **Dart SDK**: Included with Flutter.
*   **Java JDK**: Required for building the Android version of the app.
*   **VS Code / Android Studio**: Your favorite code editor with Flutter extensions installed.
*   **Mobile Emulator**: An Android Emulator or iOS Simulator (or a real physical phone).

### 2. Minimum System Requirements
*   **OS**: Windows 10/11, macOS, or Linux.
*   **RAM**: At least 8GB (16GB recommended for smooth development).
*   **Disk Space**: At least 10GB for SDKs and tools.

---

## 📁 Project Structure

Here is a simple look at how the code is organized in the `lib` folder:

*   **`lib/auth/`**: Contains everything related to logging in, signing up, and resetting passwords.
*   **`lib/traveler/`**: Screens and logic for the traveler (Searching for hotels, booking, viewing profile).
*   **`lib/provider/`**: Screens for service owners to add new services (like hotels) and manage their bookings.
*   **`lib/admin/`**: High-level tools for administrators to manage users and see financial stats.
*   **`lib/shared/`**: Common parts of the app used everywhere, like simple buttons, data models, or layouts.
*   **`lib/core/`**: The foundation of the app, including the theme colors and navigation rules.
*   **`main.dart`**: The starting point of the whole application.

---

## ✨ Features / Modules

### 👑 Admin Module
*   **Dashboard**: Overview of total users, active services, and revenue.
*   **User Management**: Ability to create, edit, or remove admins and providers.
*   **Financial Reports**: Detailed view of earnings and transactions.

### 🏨 Provider Module
*   **Service Creation**: A step-by-step form to list Hotels, Apartments, or Transport.
*   **Booking Tracker**: Manage incoming bookings (Confirm or Cancel).
*   **Earnings View**: Track how much money is being made from listings.

### 🎒 Traveler Module
*   **Search & Filters**: Find the perfect stay based on category and type.
*   **Secure Booking**: Simple process to book a service and pay (simulated).
*   **Booking History**: Keep track of all past and upcoming trips.

---

## ⚙️ Installation / Setup

Follow these steps to get the app running on your machine:

1.  **Clone the Project**:
    Download the code or use git:
    ```bash
    git clone https://github.com/ahmedOsman64/somsafar_booking.git
    ```

2.  **Install Dependencies**:
    Open your terminal in the project folder and run:
    ```bash
    flutter pub get
    ```

3.  **Setup Firebase**:
    *   Create a project on the [Firebase Console](https://console.firebase.google.com/).
    *   Add an Android and/or iOS app.
    *   Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS).
    *   Place them in the correct folders (`android/app/` or `ios/Runner/`).

4.  **Run the App**:
    Connect your phone or start an emulator, then run:
    ```bash
    flutter run
    ```

---

## 📱 Usage

Once the app starts:
1.  **Sign Up**: Create a new account as a **Traveler**.
2.  **Explore**: Use the search bar on the home screen to find hotels.
3.  **Book**: Tap on a hotel, see its details, and click "Book Now".
4.  **Admin Access**: If you have an admin account, use the drawer menu to access the Admin Dashboard.

---

## 🤝 Contributing

We love help from the community! If you want to contribute:
1.  Fork the project.
2.  Create a new branch (`git checkout -b feature-name`).
3.  Make your changes and commit them (`git commit -m 'Add new feature'`).
4.  Push to the branch (`git push origin feature-name`).
5.  Open a Pull Request.

---

## ⚖️ License

This project is licensed under the **MIT License**. You are free to use, modify, and distribute it.

---

*Made with ❤️ for a better travel experience.*
