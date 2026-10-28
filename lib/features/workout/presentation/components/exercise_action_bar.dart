import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:calistracker/features/workout/presentation/bloc/workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Bottom bar with the set counter and the set / hold / done button.
class ExerciseActionBar extends StatelessWidget {
  const ExerciseActionBar({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSizes.bodyPadding,
        child: BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (context, state) {
            final cubit = context.read<WorkoutCubit>();

            return Column(
              spacing: 8.h,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: AppStrings.exerciseSets(
                    state.setsDone,
                    state.totalSets,
                  ),
                  fWeight: FontWeight.w600,
                ),
                if (state.isFinished)
                  AppButton(
                    text: AppStrings.exerciseMarkAsDone,
                    onPressed: () {
                      context.read<ProgressBloc>().add(
                        ExerciseCompleted(exercise.id),
                      );
                      context.pop();
                    },
                  )
                else if (exercise.isHold)
                  AppButton(
                    text: state.isHolding
                        ? AppStrings.exerciseHolding(state.secondsLeft)
                        : AppStrings.exerciseStartHold(exercise.holdSeconds),
                    onPressed: state.isHolding ? null : cubit.startHold,
                  )
                else
                  AppButton(
                    text: AppStrings.exerciseCompleteSet(exercise.reps),
                    onPressed: cubit.completeSet,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
