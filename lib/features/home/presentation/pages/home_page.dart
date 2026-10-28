import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/home/presentation/components/continue_card.dart';
import 'package:calistracker/features/home/presentation/components/overall_progress_card.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:calistracker/features/programs/presentation/components/program_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProgramsBloc, ProgramsState>(
          builder: (context, programsState) {
            switch (programsState.status) {
              case ProgramsStatus.initial:
              case ProgramsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case ProgramsStatus.failure:
                return _ErrorView(message: programsState.error);
              case ProgramsStatus.success:
                return BlocBuilder<ProgressBloc, ProgressState>(
                  builder: (context, progress) => _HomeContent(
                    programs: programsState.programs,
                    total: programsState.totalExercises,
                    completed: progress.completed,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.programs,
    required this.total,
    required this.completed,
  });

  final List<Program> programs;
  final int total;
  final Set<String> completed;

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
                text: HomePage._greeting(),
                fSize: 13.sp,
                textColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              AppText(
                text: 'Ready to train?',
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
                text: 'Exercise types',
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSizes.bodyPadding,
        child: Column(
          spacing: 12.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: message ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
            AppButton(
              width: 160.w,
              text: 'Try again',
              onPressed: () =>
                  context.read<ProgramsBloc>().add(const ProgramsRequested()),
            ),
          ],
        ),
      ),
    );
  }
}
