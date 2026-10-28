import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:equatable/equatable.dart';

/// An ordered progression: each exercise unlocks after the previous one.
class Program extends Equatable {
  const Program({
    required this.id,
    required this.name,
    required this.description,
    required this.exercises,
  });

  final String id;
  final String name;
  final String description;
  final List<Exercise> exercises;

  int completedCount(Set<String> completedIds) =>
      exercises.where((e) => completedIds.contains(e.id)).length;

  bool isUnlocked(int index, Set<String> completedIds) =>
      index == 0 || completedIds.contains(exercises[index - 1].id);

  /// Later exercises in a progression are harder.
  Difficulty difficultyOf(int index) {
    final position = index / exercises.length;
    if (position < 1 / 3) return Difficulty.beginner;
    if (position < 2 / 3) return Difficulty.intermediate;
    return Difficulty.advanced;
  }

  /// First exercise that is unlocked but not yet completed, if any.
  Exercise? nextExercise(Set<String> completedIds) {
    for (var i = 0; i < exercises.length; i++) {
      if (!completedIds.contains(exercises[i].id) &&
          isUnlocked(i, completedIds)) {
        return exercises[i];
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [id, name, description, exercises];
}

enum Difficulty {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  const Difficulty(this.label);

  final String label;
}
