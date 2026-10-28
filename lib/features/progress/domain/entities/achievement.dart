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
];

List<AchievementStatus> evaluateAchievements(AchievementContext context) => [
  for (final a in achievements) AchievementStatus(a, a.isUnlocked(context)),
];
