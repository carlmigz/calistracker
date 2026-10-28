part of 'progress_bloc.dart';

class ProgressState extends Equatable {
  const ProgressState({this.progress = const UserProgress(), this.error});

  final UserProgress progress;
  final String? error;

  Set<String> get completed => progress.completedIds;

  ProgressState copyWith({String? error}) =>
      ProgressState(progress: progress, error: error);

  @override
  List<Object?> get props => [progress, error];
}
