import 'package:calistracker/core/components/section_header.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/features/home/presentation/components/continue_card.dart';
import 'package:calistracker/features/home/presentation/components/daily_goal_card.dart';
import 'package:calistracker/features/home/presentation/components/daily_tip_card.dart';
import 'package:calistracker/features/home/presentation/components/featured_program_card.dart';
import 'package:calistracker/features/home/presentation/components/home_header.dart';
import 'package:calistracker/features/home/presentation/components/level_card.dart';
import 'package:calistracker/features/home/presentation/components/overall_progress_card.dart';
import 'package:calistracker/features/home/presentation/components/quick_actions.dart';
import 'package:calistracker/features/home/presentation/components/recent_activity.dart';
import 'package:calistracker/features/home/presentation/components/reveal.dart';
import 'package:calistracker/features/home/presentation/components/stats_tiles.dart';
import 'package:calistracker/features/home/presentation/components/streak_card.dart';
import 'package:calistracker/features/home/presentation/components/weekly_activity_strip.dart';
import 'package:calistracker/features/home/presentation/components/welcome_card.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:calistracker/features/programs/presentation/components/program_grid_card.dart';
import 'package:calistracker/features/progress/domain/entities/achievement.dart';
import 'package:calistracker/features/progress/domain/entities/user_level.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.programs,
    required this.total,
    required this.completed,
    required this.progress,
  });

  final List<Program> programs;
  final int total;
  final Set<String> completed;
  final UserProgress progress;

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

  /// First program not started yet, else the unfinished one furthest along.
  Program? get _featured {
    final open = programs
        .where((p) => p.completedCount(completed) < p.exercises.length)
        .toList();
    if (open.isEmpty) return null;
    for (final p in open) {
      if (p.completedCount(completed) == 0) return p;
    }
    return open.reduce(
      (a, b) =>
          a.completedCount(completed) / a.exercises.length >=
              b.completedCount(completed) / b.exercises.length
          ? a
          : b,
    );
  }

  Future<void> _refresh(BuildContext context) async {
    context.read<ProgramsBloc>().add(const ProgramsRequested());
    context.read<ProgressBloc>().add(const ProgressRequested());
    // The blocs reload from local storage almost instantly; keep the spinner
    // visible long enough to read as a refresh.
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final next = _next;
    final now = DateTime.now();
    final featured = _featured;
    final recent = progress.recent(3);
    final isNewUser = progress.completions.isEmpty;
    final settings = context.select<SettingsCubit, SettingsState>(
      (c) => c.state,
    );
    final activity = progress.activityLast7Days(now);

    final sections = <Widget>[
      HomeHeader(
        greeting: _greeting(),
        name: settings.displayName,
        avatarColor: settings.avatarColor,
        avatarAsset: settings.avatarPose,
      ),
      SizedBox(height: 16.h),
      ContinueCard(
        exercise: next?.exercise,
        programName: next?.program.name ?? '',
        onTap: () => context.push(
          AppRoutes.exercise(next!.program.id, next.exercise.id),
        ),
      ),
      SizedBox(height: 12.h),
      OverallProgressCard(
        completed: completed.length.clamp(0, total),
        total: total,
      ),
      if (isNewUser) ...[SizedBox(height: 12.h), const WelcomeCard()],
      const SectionHeader(title: AppStrings.homeToday),
      IntrinsicHeight(
        child: Row(
          spacing: 12.w,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreakCard(
                current: progress.currentStreak(now),
                best: progress.longestStreak,
              ),
            ),
            Expanded(
              child: DailyGoalCard(
                done: activity.last,
                goal: settings.dailyGoal,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 12.h),
      WeeklyActivityStrip(
        activity: activity,
        now: now,
        weeklyGoal: settings.weeklyGoal,
      ),
      const SectionHeader(title: AppStrings.homeYourLevel),
      LevelCard(
        level: UserLevel.forCompleted(completed.length),
        unlockedAchievements: evaluateAchievements(
          AchievementContext(progress: progress, programs: programs, now: now),
        ).where((a) => a.unlocked).length,
        totalAchievements: achievements.length,
      ),
      if (!isNewUser) ...[
        SizedBox(height: 12.h),
        StatsTiles(
          sessions: progress.completions.length,
          exercises: completed.length,
          activeDays: progress.dailyCounts.length,
        ),
      ],
      const SectionHeader(title: AppStrings.homeQuickActions),
      const QuickActions(),
      if (featured != null) ...[
        const SectionHeader(title: AppStrings.homeRecommended),
        FeaturedProgramCard(
          program: featured,
          completed: completed,
          onTap: () => context.push(AppRoutes.program(featured.id)),
        ),
      ],
      if (recent.isNotEmpty) ...[
        const SectionHeader(title: AppStrings.homeRecentActivity),
        RecentActivity(
          completions: recent,
          names: {
            for (final p in programs)
              for (final e in p.exercises) e.id: e.name,
          },
          now: now,
        ),
      ],
      const SectionHeader(title: AppStrings.homeExerciseTypes),
    ];

    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: AppSizes.bodyPadding.copyWith(bottom: 0),
            // Not lazy, so scrolling back does not replay the entry animation.
            sliver: SliverList.list(
              children: [
                for (var i = 0; i < sections.length; i++)
                  Reveal(index: i, child: sections[i]),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                onTap: () =>
                    context.push(AppRoutes.program(programs[index].id)),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(12.w, 24.h, 12.w, 24.h),
            sliver: SliverToBoxAdapter(child: DailyTipCard(now: now)),
          ),
        ],
      ),
    );
  }
}
