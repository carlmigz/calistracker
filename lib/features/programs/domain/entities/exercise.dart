import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.muscles,
    required this.steps,
    required this.sets,
    this.reps,
    this.holdSeconds,
    this.poseAsset,
  });

  final String id;
  final String name;
  final String description;
  final List<String> muscles;
  final List<String> steps;
  final int sets;

  /// Rep-based exercises set [reps]; timed holds set [holdSeconds].
  final int? reps;
  final int? holdSeconds;

  /// Asset path of the yellow guy pose; falls back to the default mascot.
  final String? poseAsset;

  bool get isHold => holdSeconds != null;

  String get target =>
      isHold ? '$sets × ${holdSeconds}s' : '$sets × $reps reps';

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    muscles,
    steps,
    sets,
    reps,
    holdSeconds,
    poseAsset,
  ];
}
