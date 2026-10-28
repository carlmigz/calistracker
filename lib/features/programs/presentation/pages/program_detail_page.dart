import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:calistracker/features/programs/presentation/components/program_exercise_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProgramDetailPage extends StatelessWidget {
  const ProgramDetailPage({super.key, required this.programId});

  final String programId;

  @override
  Widget build(BuildContext context) {
    final program = context.select(
      (ProgramsBloc bloc) => bloc.state.programById(programId),
    );
    final completed = context.select(
      (ProgressBloc bloc) => bloc.state.completed,
    );

    if (program == null) {
      return const Scaffold(
        body: Center(child: Text(AppStrings.programNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(program.name)),
      body: ListView.separated(
        padding: AppSizes.bodyPadding,
        itemCount: program.exercises.length,
        separatorBuilder: (_, _) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final exercise = program.exercises[index];

          return ProgramExerciseTile(
            exercise: exercise,
            number: index + 1,
            isDone: completed.contains(exercise.id),
            isUnlocked: program.isUnlocked(index, completed),
            onTap: () =>
                context.push(AppRoutes.exercise(program.id, exercise.id)),
          );
        },
      ),
    );
  }
}
