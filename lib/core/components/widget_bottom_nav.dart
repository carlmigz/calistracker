import 'package:calistracker/features/home/presentation/pages/home_page.dart';
import 'package:calistracker/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class WidgetBottomNav extends StatefulWidget {
  const WidgetBottomNav({super.key});

  @override
  State<WidgetBottomNav> createState() => _WidgetBottomNavState();
}

class _WidgetBottomNavState extends State<WidgetBottomNav> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [const HomePage(), const ProfilePage()];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
        selectedIndex: index,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: [
          NavigationDestination(
            icon: Icon(
              index == 0 ? Ionicons.home : Ionicons.home_outline,
              color: index == 0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
            ),

            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              index == 1 ? Ionicons.person : Ionicons.person_outline,
              color: index == 1
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
            ),

            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
