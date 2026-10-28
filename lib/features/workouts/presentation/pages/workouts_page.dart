import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/library/presentation/pages/library_view.dart';
import 'package:calistracker/features/workouts/presentation/components/exercise_browser.dart';
import 'package:flutter/material.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.navWorkouts),
          bottom: const TabBar(
            tabs: [
              Tab(text: AppStrings.workoutsExercisesTab),
              Tab(text: AppStrings.workoutsLibraryTab),
            ],
          ),
        ),
        body: const TabBarView(children: [ExerciseBrowser(), LibraryView()]),
      ),
    );
  }
}
