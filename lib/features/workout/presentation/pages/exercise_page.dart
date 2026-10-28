import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:calistracker/features/workout/presentation/bloc/workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
        body: const Center(child: Text('Exercise not found')),
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
          Center(
            child: PoseImage(asset: exercise.poseAsset, height: 200.h),
          ),
          SizedBox(height: 12.h),
          AppText(text: exercise.description),
          SizedBox(height: 4.h),
          AppText(
            text:
                'Target: ${exercise.target}  •  ${exercise.muscles.join(', ')}',
            fSize: 12.sp,
          ),
          SizedBox(height: 16.h),
          AppText(
            text: 'How to',
            fFamily: AppTextStyles.fontFamily,
            fWeight: FontWeight.bold,
            fSize: 16.sp,
          ),
          SizedBox(height: 4.h),
          for (final (i, step) in exercise.steps.indexed)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: AppText(text: '${i + 1}. $step'),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
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
                    text: 'Sets: ${state.setsDone} / ${state.totalSets}',
                    fWeight: FontWeight.w600,
                  ),
                  if (state.isFinished)
                    AppButton(
                      text: 'Mark as done',
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
                          ? 'Hold… ${state.secondsLeft}s'
                          : 'Start hold (${exercise.holdSeconds}s)',
                      onPressed: state.isHolding ? null : cubit.startHold,
                    )
                  else
                    AppButton(
                      text: 'Complete set (${exercise.reps} reps)',
                      onPressed: cubit.completeSet,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
