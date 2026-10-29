part of 'progress_bloc.dart';

sealed class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class ProgressRequested extends ProgressEvent {
  const ProgressRequested();
}

class ExerciseCompleted extends ProgressEvent {
  const ExerciseCompleted(this.exerciseId);

  final String exerciseId;

  @override
  List<Object?> get props => [exerciseId];
}

class ProgressReset extends ProgressEvent {
  const ProgressReset();
}

/// Clears the completions of just these exercises (e.g. one program).
class ExercisesReset extends ProgressEvent {
  const ExercisesReset(this.exerciseIds);

  final Set<String> exerciseIds;

  @override
  List<Object?> get props => [exerciseIds];
}
