import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const _tabs = [
    (label: 'Home', icon: Icons.home_outlined, selectedIcon: Icons.home),
    (
      label: 'Workouts',
      icon: Icons.fitness_center_outlined,
      selectedIcon: Icons.fitness_center,
    ),
    (label: 'Timer', icon: Icons.timer_outlined, selectedIcon: Icons.timer),
    (
      label: 'Progress',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart,
    ),
    (label: 'Profile', icon: Icons.person_outline, selectedIcon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              icon: Icon(tab.icon, color: scheme.onSurface),
              selectedIcon: Icon(tab.selectedIcon, color: scheme.onPrimary),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}
