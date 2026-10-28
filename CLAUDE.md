# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- `flutter pub get` — install dependencies
- `flutter run` — run the app
- `flutter analyze` — lint (uses `flutter_lints`)
- `flutter test` / `flutter test test/path_test.dart` — all tests / a single file (there is currently no `test/` directory)
- `dart run flutter_launcher_icons` — regenerate app icons (config in `pubspec.yaml`)
- `dart run flutter_native_splash:create` — generate splash (its config block in `pubspec.yaml` is currently commented out)

## Architecture

Flutter app (package name `calistracker`) using feature-first clean architecture with `flutter_bloc`. Use absolute `package:calistracker/...` imports.

- `lib/core/` — shared code: `components/` (reusable `Widget*` widgets), `constants/`, `helpers/`, `themes/` (light/dark themes + colors), `router/`, `error/`.
- `lib/features/<feature>/` — `auth`, `onboarding`, `home`, `profile`. Each has `data/` (datasources, models, repositories impl), `domain/` (entities, repository interfaces, usecases), `presentation/` (`bloc/`, `components/`, `pages/`). Most layers are still empty `.gitkeep` placeholders; only `presentation/pages/` has code so far.
- Navigation is `go_router`, defined in `lib/core/router/app_router.dart` (`AppRoutes` + `appRouter`). `main.dart` uses `MaterialApp.router` wrapped in `ScreenUtilInit` and `ToastificationWrapper`. The `/` route is `WidgetBottomNav` (tab shell for home/profile).
- Intended conventions: `dartz` `Either<Failure, T>` for usecase results, `equatable` for states/events/entities. `get` was removed — don't reintroduce it.
- UI sizing uses `flutter_screenutil` (`.h`, `.w`, `.sp`); fonts are Ethnocentric and Poppins (declared in `pubspec.yaml`).

## Notes

- Git currently shows `assets/fonts/*`, `linux/`, `macos/`, `web/` as deleted; `pubspec.yaml` still declares the fonts, so builds fail until they are restored. Also `assets/animations/` and `assets/lottie/` are declared but don't exist.
