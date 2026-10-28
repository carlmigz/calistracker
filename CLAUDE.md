# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- `flutter pub get` — install dependencies
- `flutter run` — run the app
- `flutter analyze` — lint (uses `flutter_lints`). It does not catch broken dependencies or missing assets; use `flutter build bundle` for that.
- `flutter test` / `flutter test test/programs_test.dart` — all tests / a single file
- `dart run flutter_launcher_icons` — regenerate app icons (config in `pubspec.yaml`)
- `dart run flutter_native_splash:create` — generate splash

## What the app is

CalisTracker: a free calisthenics app for beginners. Training is organized into **programs** (progressions such as push-up: wall → incline → knee → full). Exercises in a program unlock in order. Brand colors are white, black and yellow (`AppColors.primary` `0xFFFEC200`, sampled from the mascot). The "yellow guy" mascot (`assets/images/splash_yellow_guy.png`) is shown in poses via `PoseImage`; an exercise can set `poseAsset` in the JSON, otherwise the default mascot is the fallback.

## Architecture

Feature-first clean architecture with `flutter_bloc`. Use absolute `package:calistracker/...` imports. No DI container: `lib/main.dart` only initializes prefs and runs `CalisTrackerApp` (`lib/app/app.dart`: router, theme, screen util); `lib/app/app_dependencies.dart` builds the session and repositories; `lib/app/app_providers.dart` provides the session and app-wide blocs/cubits.

- `lib/core/` — `components/` (`App*` widgets, `PoseImage`), `constants/app_sizes.dart`, `helpers/validators.dart`, `themes/` (`app_theme`, `app_colors`, `app_textstyles`), `router/`, `session/`, `error/failure.dart`, `usecases/usecase.dart`.
- `lib/features/<feature>/` — `data/` (datasources, models, repository impls), `domain/` (entities, repository interfaces, usecases), `presentation/` (`bloc/`, `components/`, `pages/`). Every feature has all three layers and the `bloc/`, `components/`, `pages/` folders (some are empty, so git does not track them). Features: `programs` (content), `progress` (completions, stats page), `workout` (set/hold cubit + exercise page), `workouts` (exercise browser + `library` tab), `timer` (rest/interval cubit), `home`, `profile`, `auth`, `onboarding`.
- Usecases return `Either<Failure, T>` (`dartz`); states/events/entities use `equatable`.
- **Content** is local JSON: `assets/data/programs.json` (placeholder content). **Progress** is a list of timestamped completions in `shared_preferences` (`id|epochMillis`; the old ids-only `completed_exercises` key is migrated with an unknown date that is ignored for streaks). `UserProgress` derives streaks, weekly activity and achievements/levels. Display name and theme mode live in `SettingsCubit`.
- `ProgramsBloc` and `ProgressBloc` are provided app-wide in `app_providers.dart`; pages look up programs/exercises by id from `ProgramsBloc` state.
- **Routing** (`core/router/app_router.dart`): `go_router` with a `StatefulShellRoute.indexedStack` with 5 tabs (Home, Workouts, Timer, Progress, Profile); the exercise route is top-level (`/exercise/:programId/:exerciseId`) on the root navigator, so it opens from any tab and hides the tab bar. Redirects are driven by `AppSession` (onboarding-seen and logged-in flags in prefs): onboarding → login → home. Login is a local stub (no validation, no backend: Sign In just sets the flag). The router is created once in `_CalisTrackerAppState`.
- **Theme**: `AppTheme.light/dark`; colors come from the `ColorScheme` (`onPrimary` is black, for text on yellow). `AppTextStyles` hold sizes/weights only (uses `.sp`, so only use inside `ScreenUtilInit`). Fonts: Ethnocentric for headings, Poppins for body (`fonts/`).

## Notes

- Firebase was removed (no `firebase_options.dart`, no packages). `get` and `ionicons` were removed too: `ionicons` 0.2.2 doesn't compile with current Flutter, so use Material `Icons`.
- Android `applicationId`/namespace is still `com.example.calistracker`; change before release.
