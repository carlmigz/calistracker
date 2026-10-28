import 'package:calistracker/core/error/failure.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:dartz/dartz.dart';

abstract class ProgressRepository {
  Future<Either<Failure, UserProgress>> getProgress();

  /// Records a completion of [exerciseId] now and returns the updated progress.
  Future<Either<Failure, UserProgress>> completeExercise(String exerciseId);

  Future<Either<Failure, UserProgress>> resetProgress();
}
