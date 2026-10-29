import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:calistracker/features/progress/domain/entities/achievement.dart';
import 'package:calistracker/features/progress/domain/entities/user_level.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Everything the profile screens derive from settings, progress and programs.
class ProfileData {
  ProfileData._({
    required this.settings,
    required this.progress,
    required this.programs,
    required this.now,
  }) : achievementContext = AchievementContext(
         progress: progress,
         programs: programs,
         now: now,
       );

  /// Subscribes [context] to all three sources.
  factory ProfileData.watch(BuildContext context) => ProfileData._(
    settings: context.watch<SettingsCubit>().state,
    progress: context.watch<ProgressBloc>().state.progress,
    programs: context.watch<ProgramsBloc>().state.programs,
    now: DateTime.now(),
  );

  final SettingsState settings;
  final UserProgress progress;
  final List<Program> programs;
  final DateTime now;
  final AchievementContext achievementContext;

  int get completedCount => achievementContext.completedCount;

  UserLevel get level => UserLevel.forCompleted(completedCount);

  List<AchievementStatus> get statuses =>
      evaluateAchievements(achievementContext);

  int get unlockedCount => statuses.where((s) => s.unlocked).length;

  int get totalExercises =>
      programs.fold(0, (sum, p) => sum + p.exercises.length);

  int get doneToday => progress.activityLast7Days(now).last;

  int get activeDaysThisWeek =>
      progress.activityLast7Days(now).where((n) => n > 0).length;

  /// Plain-text summary for the "copy progress" action.
  String summary(String title) {
    final done = progress.completedIds;
    return [
      '$title · ${settings.displayName}',
      'Exercises: ${done.length}',
      'Sessions: ${progress.completions.length}',
      'Day streak: ${achievementContext.streak}',
      'Best streak: ${progress.longestStreak}',
      for (final p in programs)
        '${p.name}: ${p.completedCount(done)}/${p.exercises.length}',
    ].join('\n');
  }
}
