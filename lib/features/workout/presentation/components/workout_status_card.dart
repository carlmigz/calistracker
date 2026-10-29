import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:calistracker/features/workout/presentation/bloc/workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Live status of the session: current set, hold countdown, or rest countdown.
class WorkoutStatusCard extends StatelessWidget {
  const WorkoutStatusCard({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutCubit, WorkoutState>(
      builder: (context, state) {
        final scheme = Theme.of(context).colorScheme;
        final cubit = context.read<WorkoutCubit>();

        final Widget content;
        if (state.isFinished) {
          content = _Message(
            icon: Icons.check_circle_rounded,
            title: AppStrings.exerciseAllSetsDone,
            hint: AppStrings.exerciseAllSetsHint,
          );
        } else if (state.isResting) {
          content = Row(
            spacing: 16.w,
            children: [
              _Ring(
                value: state.restProgress,
                label: '${state.restLeft}',
                color: scheme.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: AppStrings.exerciseRest,
                      fFamily: AppTextStyles.headingFontFamily,
                      fSize: 18.sp,
                    ),
                    AppText(text: AppStrings.exerciseRestHint, fSize: 12.sp),
                    SizedBox(height: 6.h),
                    TextButton.icon(
                      onPressed: cubit.skipRest,
                      icon: const Icon(Icons.skip_next_rounded),
                      label: const Text(AppStrings.exerciseSkipRest),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (state.isHolding) {
          content = Row(
            spacing: 16.w,
            children: [
              _Ring(
                value: state.holdProgress,
                label: '${state.secondsLeft}',
                color: scheme.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: AppStrings.exerciseHoldGo,
                      fFamily: AppTextStyles.headingFontFamily,
                      fSize: 18.sp,
                    ),
                    AppText(
                      text: AppStrings.exerciseSetOf(
                        state.setsDone + 1,
                        state.totalSets,
                      ),
                      fSize: 12.sp,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          content = Column(
            children: [
              AppText(
                text: AppStrings.exerciseSetOf(
                  state.setsDone + 1,
                  state.totalSets,
                ),
                fFamily: AppTextStyles.headingFontFamily,
                fSize: 18.sp,
              ),
              SizedBox(height: 2.h),
              AppText(
                text: exercise.isHold
                    ? AppStrings.exerciseHoldGoal(exercise.holdSeconds)
                    : AppStrings.exerciseRepsGoal(exercise.reps),
                fSize: 13.sp,
              ),
            ],
          );
        }

        return AppCard(
          large: true,
          padding: EdgeInsets.all(16.r),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: KeyedSubtree(
                    key: ValueKey((
                      state.isFinished,
                      state.isResting,
                      state.isHolding,
                    )),
                    child: content,
                  ),
                ),
                SizedBox(height: 14.h),
                _SetDots(done: state.setsDone, total: state.totalSets),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.title, required this.hint});

  final IconData icon;
  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 36.r, color: Theme.of(context).colorScheme.primary),
        SizedBox(height: 4.h),
        AppText(
          text: title,
          fFamily: AppTextStyles.headingFontFamily,
          fSize: 16.sp,
        ),
        AppText(text: hint, fSize: 12.sp, textAlign: TextAlign.center),
      ],
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.value, required this.label, required this.color});

  final double value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84.r,
      height: 84.r,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: value.clamp(0.0, 1.0),
            strokeWidth: 7.r,
            strokeCap: StrokeCap.round,
            color: color,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.12),
          ),
          Center(
            child: AppText(
              text: label,
              fFamily: AppTextStyles.headingFontFamily,
              fSize: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}

/// One dot per set; filled for finished sets, outlined for the current one.
class _SetDots extends StatelessWidget {
  const _SetDots({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8.w,
      children: [
        for (var i = 0; i < total; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: i == done ? 28.w : 12.w,
            height: 12.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: i < done ? scheme.primary : Colors.transparent,
              border: Border.all(
                color: i <= done
                    ? scheme.primary
                    : scheme.onSurface.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
          ),
      ],
    );
  }
}
