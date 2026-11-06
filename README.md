# CalisTracker 🤸‍♂️⚡

> **Master bodyweight training from zero.** CalisTracker is a modern, beginner-friendly calisthenics workout guide and fitness tracker designed to guide you through step-by-step bodyweight exercise progressions.

[![Flutter](https://img.shields.io/badge/Flutter-3.8%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8%2B-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/Bloc-flutter__bloc-blue)](https://bloclibrary.dev)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS-lightgrey)](#)
[![Theme](https://img.shields.io/badge/Theme-Light%20%26%20Dark-FEC200)](#)

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Calisthenics Progression Paths](#-calisthenics-progression-paths)
- [App Architecture](#-app-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [Testing & Quality](#-testing--quality)
- [Companion API](#-companion-api)
- [Design & Brand Identity](#-design--brand-identity)
- [License](#-license)

---

## 🌟 Overview

Calisthenics can be intimidating for beginners who cannot yet perform a single pull-up, dip, or strict push-up. **CalisTracker** demystifies bodyweight fitness by organizing workouts into **progressive milestones**. 

Starting from foundational entry-level variations (like wall push-ups and dead hangs), users unlock more demanding exercises only after mastering the fundamentals—ensuring steady strength gains and safe joint adaptation.

---

## ✨ Key Features

- 🪜 **Progression-Based Training**: Exercises unlock sequentially. Master earlier variations before advancing to advanced variations.
- 🎯 **Interactive Workout Execution**: Guided workout screens with active set tracking, repetition counters, and countdown timers for isometric holds.
- 🤖 **Visual Pose Guide**: Featuring the signature **Yellow Guy** mascot illustrating exercise postures, body mechanics, and form.
- ⏱️ **Integrated Rest & Interval Timer**: Built-in workout timer with customizable rest periods and interval tracking.
- 📊 **Streak & Progress Tracking**: Log completed exercises with timestamps, track weekly activity frequency, monitor training streaks, and earn milestone achievements.
- 🌓 **Dynamic Theme Engine**: Tailored dark and light themes optimized for gym environments and high outdoor visibility.
- 📱 **Adaptive UI**: Responsive layouts built with `flutter_screenutil` supporting varying screen sizes and orientations.

---

## 🏋️ Calisthenics Progression Paths

CalisTracker comes pre-loaded with comprehensive beginner-to-intermediate progression tracks:

| Progression | Focus Muscle Groups | Movement Pathway |
| :--- | :--- | :--- |
| **Push-Up** | Chest, Shoulders, Triceps | Wall Push-Up ➔ Incline Push-Up ➔ Knee Push-Up ➔ Full Push-Up |
| **Pull-Up** | Lats, Back, Biceps, Forearms | Dead Hang ➔ Inverted Row ➔ Negative Pull-Up ➔ Full Pull-Up |
| **Squat** | Quadriceps, Glutes, Hamstrings | Assisted Squat ➔ Bodyweight Squat ➔ Split Squat |
| **Core** | Abs, Obliques, Lower Back | Knee Plank ➔ Full Plank ➔ Hollow Body Hold |
| **Dips** | Triceps, Chest, Anterior Deltoids | Bench Dip ➔ Parallel Bar Support Hold ➔ Negative Dip ➔ Full Bar Dip |
| **Handstand** | Deltoids, Scapular Stabilizers, Wrists | Pike Hold ➔ Wall Walk ➔ Wall Handstand Hold |

---

## 🏗️ App Architecture

The app follows **Feature-First Clean Architecture** powered by `flutter_bloc`:

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   (Pages, Widgets/Components, BLoCs & Cubits, Router)  │
├────────────────────────────────────────────────────────┤
│                      Domain Layer                      │
│     (Entities, Usecases [Either<Failure, T>], Repo IF) │
├────────────────────────────────────────────────────────┤
│                       Data Layer                       │
│    (Models, JSON / Shared Preferences Data Sources)    │
└────────────────────────────────────────────────────────┘
```

- **Feature-First**: Each domain feature lives inside `lib/features/<feature_name>/` containing isolated `data`, `domain`, and `presentation` layers.
- **Robust Error Handling**: Domain use cases utilize functional programming paradigms via `dartz` (`Either<Failure, T>`).
- **Declarative Navigation**: Built on `go_router` utilizing `StatefulShellRoute.indexedStack` across 5 core tabs (Home, Workouts, Timer, Progress, Profile) with root-level deep links for active workout execution.

---

## 🛠️ Tech Stack

### Mobile Client (Flutter)
- **Framework**: [Flutter](https://flutter.dev) (v3.8+)
- **Language**: [Dart](https://dart.dev)
- **State Management**: `flutter_bloc` & `equatable`
- **Routing**: `go_router`
- **Local Storage**: `shared_preferences`
- **UI & Styling**: `flutter_screenutil`, `flutter_svg`, `gap`, `toastification`
- **Typography**: Ethnocentric (Headings) & Poppins (Body)

### Backend Service (Optional)
- **Runtime**: PHP & Laravel (`calistracker-api/`)
- **Database / ORM**: PostgreSQL & Eloquent
- **Authentication**: Laravel Sanctum bearer tokens & bcrypt

---

## 📂 Project Structure

```text
calistracker/
├── assets/
│   ├── data/
│   │   └── programs.json          # Workout curricula and exercise data
│   ├── icons/                     # Launcher and system icons
│   └── images/                    # Mascot poses and splash assets
├── fonts/                         # Custom Ethnocentric & Poppins typefaces
├── lib/
│   ├── app/                       # App root, providers, and dependency setup
│   ├── core/                      # Global widgets, theme, router, and base use cases
│   │   ├── components/            # Reusable UI widgets & PoseImage component
│   │   ├── router/                # go_router configuration & route definitions
│   │   ├── session/               # User session and persistent state
│   │   └── themes/                # AppTheme, AppColors, and text styles
│   ├── features/                  # Feature-first modular modules
│   │   ├── auth/                  # Authentication & user sign-in
│   │   ├── home/                  # Dashboard, streak overview, quick actions
│   │   ├── onboarding/            # First-run guided walkthrough
│   │   ├── profile/               # User settings and preferences
│   │   ├── programs/              # Program progressions and unlock logic
│   │   ├── progress/              # Completion history, stats, and achievements
│   │   ├── timer/                 # Rest and interval timer utility
│   │   ├── workout/               # Active workout player & rep/hold cubit
│   │   └── workouts/              # Exercise library and movement browser
│   └── main.dart                  # Application entry point
├── calistracker-api/              # Laravel + Sanctum + PostgreSQL companion API
└── pubspec.yaml                   # Package dependencies and asset registry
```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.8.1` or higher)
- [Dart SDK](https://dart.dev/get-started)
- [Android Studio](https://developer.android.com/studio) (for Android target) or [Xcode](https://developer.apple.com/xcode/) (for iOS target)
- A connected physical device or running emulator/simulator

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/calistracker.git
   cd calistracker
   ```

2. Install Flutter packages:
   ```bash
   flutter pub get
   ```

3. Verify Flutter setup:
   ```bash
   flutter doctor
   ```

### Running the App

Launch the application on an emulator or connected device:

```bash
flutter run
```

---

## 🧪 Testing & Quality

Run the test suite and static analysis tools:

```bash
# Run unit and widget tests
flutter test

# Run a specific test suite
flutter test test/programs_test.dart

# Run static code analysis and linting
flutter analyze
```

### Asset & Icon Regeneration

If updating branding or icons:

```bash
# Regenerate launcher icons
dart run flutter_launcher_icons

# Regenerate native splash screen
dart run flutter_native_splash:create
```

---

## 🔌 Companion API

CalisTracker includes an optional companion backend located in `calistracker-api/` for synchronized user accounts, remote progress tracking, and exercise curriculum management.

For instructions on configuring the PostgreSQL database and running the API server, refer to [calistracker-api/README.md](file:///c:/Users/H2/Desktop/shared/calistracker/calistracker-api/README.md).

---

## 🎨 Design & Brand Identity

- **Primary Brand Color**: CalisTracker Yellow (`#FEC200`) — energetic and high contrast.
- **Backgrounds**: Pure Light (`#FFFFFF`) & Stealth Dark (`#000000`).
- **Mascot**: The *Yellow Guy* mascot represents form, consistency, and discipline across poses and progression illustrations.
- **Typography**:
  - **Headings**: Ethnocentric (futuristic, bold, athletic).
  - **Body Text**: Poppins (clean, highly legible, modern).

---

## 📄 License

This project is private and licensed for personal development and educational purposes.
