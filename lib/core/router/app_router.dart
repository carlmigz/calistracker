import 'package:calistracker/core/components/app_bottom_nav.dart';
import 'package:calistracker/core/session/app_session.dart';
import 'package:calistracker/features/auth/presentation/pages/login_page.dart';
import 'package:calistracker/features/home/presentation/pages/home_page.dart';
import 'package:calistracker/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:calistracker/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:calistracker/features/profile/presentation/pages/profile_page.dart';
import 'package:calistracker/features/programs/presentation/pages/program_detail_page.dart';
import 'package:calistracker/features/progress/presentation/pages/progress_page.dart';
import 'package:calistracker/features/timer/presentation/pages/timer_page.dart';
import 'package:calistracker/features/workout/presentation/pages/exercise_page.dart';
import 'package:calistracker/features/workouts/presentation/pages/workouts_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  static const onboarding = '/onboarding';
  static const login = '/login';
  static const home = '/home';
  static const workouts = '/workouts';
  static const timer = '/timer';
  static const progress = '/progress';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';

  static String program(String programId) => '$home/program/$programId';

  static String exercise(String programId, String exerciseId) =>
      '/exercise/$programId/$exerciseId';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRoute _tab(String path, Widget Function() page, {List<RouteBase>? routes}) {
  return GoRoute(
    path: path,
    builder: (context, state) => page(),
    routes: routes ?? const [],
  );
}

GoRouter createRouter(AppSession session) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    refreshListenable: session.changes,
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (!session.onboardingSeen) {
        return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
      }
      if (!session.isLoggedIn) {
        return location == AppRoutes.login ? null : AppRoutes.login;
      }
      if (location == AppRoutes.login || location == AppRoutes.onboarding) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      // Full-screen workout: opened from any tab, hides the bottom bar.
      GoRoute(
        path: '/exercise/:programId/:exerciseId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ExercisePage(
          programId: state.pathParameters['programId']!,
          exerciseId: state.pathParameters['exerciseId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfilePage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppBottomNav(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              _tab(
                AppRoutes.home,
                () => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'program/:programId',
                    builder: (context, state) => ProgramDetailPage(
                      programId: state.pathParameters['programId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [_tab(AppRoutes.workouts, () => const WorkoutsPage())],
          ),
          StatefulShellBranch(
            routes: [_tab(AppRoutes.timer, () => const TimerPage())],
          ),
          StatefulShellBranch(
            routes: [_tab(AppRoutes.progress, () => const ProgressPage())],
          ),
          StatefulShellBranch(
            routes: [_tab(AppRoutes.profile, () => const ProfilePage())],
          ),
        ],
      ),
    ],
  );
}
