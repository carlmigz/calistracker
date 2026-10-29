import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.isUnlocked,
  });

  final String id;
  final String title;
  final String description;
  final bool Function(AchievementContext context) isUnlocked;
}

class AchievementContext {
  const AchievementContext({
    required this.progress,
    required this.programs,
    required this.now,
  });

  final UserProgress progress;
  final List<Program> programs;
  final DateTime now;

  int get completedCount => progress.completedIds.length;
  int get streak => progress.currentStreak(now);

  int get completedPrograms => programs
      .where(
        (p) =>
            p.exercises.isNotEmpty &&
            p.completedCount(progress.completedIds) == p.exercises.length,
      )
      .length;

  int get longestStreak => progress.longestStreak;
  int get sessions => progress.completions.length;
  int get bestDay => progress.bestDayCount;
  int get activeDays => progress.dailyCounts.length;

  int get totalExercises =>
      programs.fold(0, (sum, p) => sum + p.exercises.length);

  bool get completedEverything =>
      totalExercises > 0 && completedCount >= totalExercises;

  Iterable<DateTime> get _times => progress.completions
      .where((c) => c.hasKnownDate)
      .map((c) => c.completedAt);

  bool get trainedBeforeEight => _times.any((t) => t.hour < 8);
  bool get trainedAfterNine => _times.any((t) => t.hour >= 21);

  bool get trainedSaturdayAndSunday =>
      _times.any((t) => t.weekday == DateTime.saturday) &&
      _times.any((t) => t.weekday == DateTime.sunday);

  bool get touchedEveryProgram =>
      programs.isNotEmpty &&
      programs.every((p) => p.completedCount(progress.completedIds) > 0);
}

class AchievementStatus {
  const AchievementStatus(this.achievement, this.unlocked);

  final Achievement achievement;
  final bool unlocked;
}

final achievements = <Achievement>[
  Achievement(
    id: 'first_step',
    title: 'First Step',
    description: 'Complete your first exercise.',
    isUnlocked: (c) => c.completedCount >= 1,
  ),
  Achievement(
    id: 'high_five',
    title: 'High Five',
    description: 'Complete 5 different exercises.',
    isUnlocked: (c) => c.completedCount >= 5,
  ),
  Achievement(
    id: 'all_rounder',
    title: 'All-Rounder',
    description: 'Try every exercise type at least once.',
    isUnlocked: (c) => c.touchedEveryProgram,
  ),
  Achievement(
    id: 'program_master',
    title: 'Program Master',
    description: 'Finish a whole progression.',
    isUnlocked: (c) => c.completedPrograms >= 1,
  ),
  Achievement(
    id: 'streak_3',
    title: 'On a Roll',
    description: 'Train 3 days in a row.',
    isUnlocked: (c) => c.streak >= 3,
  ),
  Achievement(
    id: 'streak_7',
    title: 'Unstoppable',
    description: 'Train 7 days in a row.',
    isUnlocked: (c) => c.streak >= 7,
  ),
  Achievement(
    id: 'ten_club',
    title: 'Ten Club',
    description: 'Complete 10 different exercises.',
    isUnlocked: (c) => c.completedCount >= 10,
  ),
  Achievement(
    id: 'completionist',
    title: 'Completionist',
    description: 'Complete every exercise in the app.',
    isUnlocked: (c) => c.completedEverything,
  ),
  Achievement(
    id: 'streak_14',
    title: 'Two-Week Warrior',
    description: 'Train 14 days in a row.',
    isUnlocked: (c) => c.longestStreak >= 14,
  ),
  Achievement(
    id: 'streak_30',
    title: 'Iron Habit',
    description: 'Train 30 days in a row.',
    isUnlocked: (c) => c.longestStreak >= 30,
  ),
  Achievement(
    id: 'sessions_25',
    title: 'Regular',
    description: 'Finish 25 sessions.',
    isUnlocked: (c) => c.sessions >= 25,
  ),
  Achievement(
    id: 'sessions_100',
    title: 'Centurion',
    description: 'Finish 100 sessions.',
    isUnlocked: (c) => c.sessions >= 100,
  ),
  Achievement(
    id: 'triple_threat',
    title: 'Triple Threat',
    description: 'Finish 3 exercises in one day.',
    isUnlocked: (c) => c.bestDay >= 3,
  ),
  Achievement(
    id: 'power_day',
    title: 'Power Day',
    description: 'Finish 5 exercises in one day.',
    isUnlocked: (c) => c.bestDay >= 5,
  ),
  Achievement(
    id: 'active_10',
    title: 'Showing Up',
    description: 'Train on 10 different days.',
    isUnlocked: (c) => c.activeDays >= 10,
  ),
  Achievement(
    id: 'early_bird',
    title: 'Early Bird',
    description: 'Finish an exercise before 8 AM.',
    isUnlocked: (c) => c.trainedBeforeEight,
  ),
  Achievement(
    id: 'night_owl',
    title: 'Night Owl',
    description: 'Finish an exercise after 9 PM.',
    isUnlocked: (c) => c.trainedAfterNine,
  ),
  Achievement(
    id: 'weekend_warrior',
    title: 'Weekend Warrior',
    description: 'Train on a Saturday and a Sunday.',
    isUnlocked: (c) => c.trainedSaturdayAndSunday,
  ),
];

List<AchievementStatus> evaluateAchievements(AchievementContext context) => [
  for (final a in achievements) AchievementStatus(a, a.isUnlocked(context)),
];
