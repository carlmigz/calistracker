import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:calistracker/features/workout/presentation/bloc/workout_cubit.dart';
import 'package:calistracker/features/workout/presentation/components/exercise_action_bar.dart';
import 'package:calistracker/features/workout/presentation/components/exercise_header.dart';
import 'package:calistracker/features/workout/presentation/components/exercise_steps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({
    super.key,
    required this.programId,
    required this.exerciseId,
  });

  final String programId;
  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    final exercise = context.select(
      (ProgramsBloc bloc) => bloc.state.exerciseById(programId, exerciseId),
    );

    if (exercise == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text(AppStrings.exerciseNotFound)),
      );
    }

    return BlocProvider(
      create: (_) => WorkoutCubit(exercise),
      child: _ExerciseView(exercise: exercise),
    );
  }
}

class _ExerciseView extends StatelessWidget {
  const _ExerciseView({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: ListView(
        padding: AppSizes.bodyPadding,
        children: [
          ExerciseHeader(exercise: exercise),
          SizedBox(height: 16.h),
          ExerciseSteps(steps: exercise.steps),
        ],
      ),
      bottomNavigationBar: ExerciseActionBar(exercise: exercise),
    );
  }
}
