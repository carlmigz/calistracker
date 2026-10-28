import 'package:equatable/equatable.dart';

/// One finished session of an exercise.
class Completion extends Equatable {
  const Completion({required this.exerciseId, required this.completedAt});

  final String exerciseId;
  final DateTime completedAt;

  /// Completions migrated from the old ids-only storage have no real date.
  bool get hasKnownDate => completedAt.millisecondsSinceEpoch > 0;

  @override
  List<Object?> get props => [exerciseId, completedAt];
}
