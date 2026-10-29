import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/workout/presentation/bloc/workout_cubit.dart';
import 'package:calistracker/features/workout/presentation/components/workout_complete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Bottom bar with undo and the set / hold / done button.
class ExerciseActionBar extends StatelessWidget {
  const ExerciseActionBar({
    super.key,
    required this.programId,
    required this.exercise,
  });

  final String programId;
  final Exercise exercise;

  Future<void> _markDone(BuildContext context, WorkoutState state) async {
    final progress = context.read<ProgressBloc>();
    final router = GoRouter.of(context);
    final program = context.read<ProgramsBloc>().state.programById(programId);
    final completed = {...progress.state.completed, exercise.id};
    final next = program?.nextExercise(completed);

    progress.add(ExerciseCompleted(exercise.id));
    final goNext = await showWorkoutCompleteDialog(
      context,
      exercise: exercise,
      elapsedSeconds: state.elapsedSeconds,
      next: next,
    );

    if (goNext && next != null) {
      router.pushReplacement(AppRoutes.exercise(programId, next.id));
    } else {
      router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSizes.bodyPadding,
        child: BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (context, state) {
            final cubit = context.read<WorkoutCubit>();

            final Widget button;
            if (state.isFinished) {
              button = AppButton(
                text: AppStrings.exerciseMarkAsDone,
                icon: Icons.check_rounded,
                onPressed: () => _markDone(context, state),
              );
            } else if (state.isResting) {
              button = AppButton(
                text: AppStrings.exerciseSkipRest,
                icon: Icons.skip_next_rounded,
                onPressed: cubit.skipRest,
              );
            } else if (exercise.isHold) {
              button = AppButton(
                text: state.isHolding
                    ? AppStrings.exerciseHolding(state.secondsLeft)
                    : AppStrings.exerciseStartHold(exercise.holdSeconds),
                icon: Icons.timer_rounded,
                onPressed: state.isHolding ? null : cubit.startHold,
              );
            } else {
              button = AppButton(
                text: AppStrings.exerciseCompleteSet(exercise.reps),
                icon: Icons.fitness_center_rounded,
                onPressed: cubit.completeSet,
              );
            }

            return Row(
              spacing: 8.w,
              children: [
                IconButton.filledTonal(
                  tooltip: AppStrings.exerciseUndoSet,
                  onPressed: state.setsDone > 0 && !state.isHolding
                      ? cubit.undoSet
                      : null,
                  icon: const Icon(Icons.undo_rounded),
                ),
                Expanded(child: button),
              ],
            );
          },
        ),
      ),
    );
  }
}
