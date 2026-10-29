import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';

enum AchievementCategory {
  milestones('Milestones'),
  streaks('Streaks'),
  volume('Volume'),
  habits('Habits');

  const AchievementCategory(this.label);

  final String label;
}

/// How far along a badge is: [current] of [target].
class AchievementProgress {
  const AchievementProgress(this.current, this.target);

  final int current;
  final int target;

  int get shown => current < target ? current : target;
  double get fraction => target <= 0 ? 0 : shown / target;
  bool get done => target > 0 && current >= target;
}

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tip,
    required this.unit,
    required this.progress,
  });

  final String id;
  final String title;
  final String description;
  final AchievementCategory category;

  /// Advice on how to get the badge, shown on its page.
  final String tip;

  /// What the progress counts, e.g. "days".
  final String unit;
  final AchievementProgress Function(AchievementContext context) progress;
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

  bool get trainedBeforeSix => _times.any((t) => t.hour < 6);
  bool get trainedBeforeEight => _times.any((t) => t.hour < 8);
  bool get trainedAfterNine => _times.any((t) => t.hour >= 21);

  int get weekendDaysTrained => [
    DateTime.saturday,
    DateTime.sunday,
  ].where((d) => _times.any((t) => t.weekday == d)).length;

  int get touchedPrograms =>
      programs.where((p) => p.completedCount(progress.completedIds) > 0).length;
}

class AchievementStatus {
  const AchievementStatus(this.achievement, this.progress);

  final Achievement achievement;
  final AchievementProgress progress;

  bool get unlocked => progress.done;
}

AchievementProgress _flag(bool done) => AchievementProgress(done ? 1 : 0, 1);

final achievements = <Achievement>[
  Achievement(
    id: 'first_step',
    title: 'First Step',
    description: 'Complete your first exercise.',
    category: AchievementCategory.milestones,
    tip:
        'Pick any exercise on the Workouts tab and finish it. Wall push-ups are a gentle start.',
    unit: 'exercises',
    progress: (c) => AchievementProgress(c.completedCount, 1),
  ),
  Achievement(
    id: 'high_five',
    title: 'High Five',
    description: 'Complete 5 different exercises.',
    category: AchievementCategory.milestones,
    tip:
        'Each exercise counts once, so unlock the next step in a program to keep moving.',
    unit: 'exercises',
    progress: (c) => AchievementProgress(c.completedCount, 5),
  ),
  Achievement(
    id: 'all_rounder',
    title: 'All-Rounder',
    description: 'Try every exercise type at least once.',
    category: AchievementCategory.milestones,
    tip: 'Finish at least one exercise in every program.',
    unit: 'programs',
    progress: (c) => AchievementProgress(c.touchedPrograms, c.programs.length),
  ),
  Achievement(
    id: 'program_master',
    title: 'Program Master',
    description: 'Finish a whole progression.',
    category: AchievementCategory.milestones,
    tip:
        'Work through every step of one program, from the easiest variation to the hardest.',
    unit: 'programs',
    progress: (c) => AchievementProgress(c.completedPrograms, 1),
  ),
  Achievement(
    id: 'streak_3',
    title: 'On a Roll',
    description: 'Train 3 days in a row.',
    category: AchievementCategory.streaks,
    tip: 'Train once a day. Even one quick exercise keeps the streak alive.',
    unit: 'days',
    progress: (c) => AchievementProgress(c.streak, 3),
  ),
  Achievement(
    id: 'streak_7',
    title: 'Unstoppable',
    description: 'Train 7 days in a row.',
    category: AchievementCategory.streaks,
    tip: 'A full week. Your current streak counts, so do not skip a day.',
    unit: 'days',
    progress: (c) => AchievementProgress(c.streak, 7),
  ),
  Achievement(
    id: 'ten_club',
    title: 'Ten Club',
    description: 'Complete 10 different exercises.',
    category: AchievementCategory.milestones,
    tip:
        'Mix programs: finishing steps in several progressions gets you there faster.',
    unit: 'exercises',
    progress: (c) => AchievementProgress(c.completedCount, 10),
  ),
  Achievement(
    id: 'completionist',
    title: 'Completionist',
    description: 'Complete every exercise in the app.',
    category: AchievementCategory.milestones,
    tip:
        'Finish every step of every program. The Programs section in your profile shows what is left.',
    unit: 'exercises',
    progress: (c) => AchievementProgress(c.completedCount, c.totalExercises),
  ),
  Achievement(
    id: 'streak_14',
    title: 'Two-Week Warrior',
    description: 'Train 14 days in a row.',
    category: AchievementCategory.streaks,
    tip:
        'Your best streak counts, so once you reach 14 days the badge is yours for good.',
    unit: 'days',
    progress: (c) => AchievementProgress(c.longestStreak, 14),
  ),
  Achievement(
    id: 'streak_30',
    title: 'Iron Habit',
    description: 'Train 30 days in a row.',
    category: AchievementCategory.streaks,
    tip:
        'A whole month. Keep sessions short on busy days so the chain never breaks.',
    unit: 'days',
    progress: (c) => AchievementProgress(c.longestStreak, 30),
  ),
  Achievement(
    id: 'sessions_25',
    title: 'Regular',
    description: 'Finish 25 sessions.',
    category: AchievementCategory.volume,
    tip:
        'Every finished exercise is a session, and repeating an exercise counts again.',
    unit: 'sessions',
    progress: (c) => AchievementProgress(c.sessions, 25),
  ),
  Achievement(
    id: 'sessions_100',
    title: 'Centurion',
    description: 'Finish 100 sessions.',
    category: AchievementCategory.volume,
    tip:
        'Repeat exercises you have already mastered to build strength and the count.',
    unit: 'sessions',
    progress: (c) => AchievementProgress(c.sessions, 100),
  ),
  Achievement(
    id: 'triple_threat',
    title: 'Triple Threat',
    description: 'Finish 3 exercises in one day.',
    category: AchievementCategory.volume,
    tip: 'Plan a longer session: three exercises in a single day.',
    unit: 'in one day',
    progress: (c) => AchievementProgress(c.bestDay, 3),
  ),
  Achievement(
    id: 'power_day',
    title: 'Power Day',
    description: 'Finish 5 exercises in one day.',
    category: AchievementCategory.volume,
    tip: 'Go big on one day. Rest between sets and finish five exercises.',
    unit: 'in one day',
    progress: (c) => AchievementProgress(c.bestDay, 5),
  ),
  Achievement(
    id: 'active_10',
    title: 'Showing Up',
    description: 'Train on 10 different days.',
    category: AchievementCategory.habits,
    tip: 'The days do not need to be in a row. Just keep coming back.',
    unit: 'days',
    progress: (c) => AchievementProgress(c.activeDays, 10),
  ),
  Achievement(
    id: 'early_bird',
    title: 'Early Bird',
    description: 'Finish an exercise before 8 AM.',
    category: AchievementCategory.habits,
    tip: 'Do a morning session. The time on your phone when you finish counts.',
    unit: 'times',
    progress: (c) => _flag(c.trainedBeforeEight),
  ),
  Achievement(
    id: 'night_owl',
    title: 'Night Owl',
    description: 'Finish an exercise after 9 PM.',
    category: AchievementCategory.habits,
    tip: 'Squeeze in a late session after 9 PM.',
    unit: 'times',
    progress: (c) => _flag(c.trainedAfterNine),
  ),
  Achievement(
    id: 'weekend_warrior',
    title: 'Weekend Warrior',
    description: 'Train on a Saturday and a Sunday.',
    category: AchievementCategory.habits,
    tip: 'Train on both weekend days. They can be from different weekends.',
    unit: 'weekend days',
    progress: (c) => AchievementProgress(c.weekendDaysTrained, 2),
  ),
  Achievement(
    id: 'sigma',
    title: 'Sigma',
    description: 'Finish an exercise before 6 AM.',
    category: AchievementCategory.habits,
    tip: 'Rise before the sun and finish an exercise before 6 AM.',
    unit: 'times',
    progress: (c) => _flag(c.trainedBeforeSix),
  ),
  Achievement(
    id: 'giga_chad',
    title: 'GigaChad',
    description: 'Complete every exercise and finish 100 sessions.',
    category: AchievementCategory.volume,
    tip:
        'The final boss: finish all exercises, then keep training until you reach 100 sessions.',
    unit: 'requirements',
    progress: (c) => AchievementProgress(
      (c.completedEverything ? 1 : 0) + (c.sessions >= 100 ? 1 : 0),
      2,
    ),
  ),
];

List<AchievementStatus> evaluateAchievements(AchievementContext context) => [
  for (final a in achievements) AchievementStatus(a, a.progress(context)),
];
