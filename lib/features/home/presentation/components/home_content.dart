import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/home/presentation/components/continue_card.dart';
import 'package:calistracker/features/home/presentation/components/overall_progress_card.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/programs/presentation/components/program_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.programs,
    required this.total,
    required this.completed,
  });

  final List<Program> programs;
  final int total;
  final Set<String> completed;

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.homeGoodMorning;
    if (hour < 18) return AppStrings.homeGoodAfternoon;
    return AppStrings.homeGoodEvening;
  }

  /// First unfinished, unlocked exercise across all programs.
  ({Program program, Exercise exercise})? get _next {
    for (final program in programs) {
      final exercise = program.nextExercise(completed);
      if (exercise != null) return (program: program, exercise: exercise);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final next = _next;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: AppSizes.bodyPadding,
          sliver: SliverList.list(
            children: [
              AppText(
                text: _greeting(),
                fSize: 13.sp,
                textColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              AppText(
                text: AppStrings.homeReadyToTrain,
                fFamily: AppTextStyles.headingFontFamily,
                fSize: 22.sp,
              ),
              SizedBox(height: 16.h),
              OverallProgressCard(
                completed: completed.length.clamp(0, total),
                total: total,
              ),
              SizedBox(height: 12.h),
              ContinueCard(
                exercise: next?.exercise,
                programName: next?.program.name ?? '',
                onTap: () => context.push(
                  AppRoutes.exercise(next!.program.id, next.exercise.id),
                ),
              ),
              SizedBox(height: 24.h),
              AppText(
                text: AppStrings.homeExerciseTypes,
                fFamily: AppTextStyles.fontFamily,
                fWeight: FontWeight.bold,
                fSize: 18.sp,
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.95,
            ),
            itemCount: programs.length,
            itemBuilder: (context, index) => ProgramGridCard(
              program: programs[index],
              completed: completed,
              onTap: () => context.push(AppRoutes.program(programs[index].id)),
            ),
          ),
        ),
      ],
    );
  }
}
