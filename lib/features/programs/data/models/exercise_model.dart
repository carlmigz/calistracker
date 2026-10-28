import 'package:calistracker/features/programs/domain/entities/exercise.dart';

class ExerciseModel extends Exercise {
  const ExerciseModel({
    required super.id,
    required super.name,
    required super.description,
    required super.muscles,
    required super.steps,
    required super.sets,
    super.reps,
    super.holdSeconds,
    super.poseAsset,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      muscles: List<String>.from(json['muscles'] as List),
      steps: List<String>.from(json['steps'] as List),
      sets: json['sets'] as int,
      reps: json['reps'] as int?,
      holdSeconds: json['holdSeconds'] as int?,
      poseAsset: json['poseAsset'] as String?,
    );
  }
}
