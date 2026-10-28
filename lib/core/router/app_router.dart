import 'package:calistracker/core/components/widget_bottom_nav.dart';
import 'package:calistracker/features/auth/presentation/pages/login_page.dart';
import 'package:calistracker/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const home = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const WidgetBottomNav(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
