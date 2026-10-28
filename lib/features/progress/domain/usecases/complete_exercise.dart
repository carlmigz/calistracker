import 'package:calistracker/core/error/failure.dart';
import 'package:calistracker/core/usecases/usecase.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:calistracker/features/progress/domain/repositories/progress_repository.dart';
import 'package:dartz/dartz.dart';

class CompleteExercise implements UseCase<UserProgress, String> {
  const CompleteExercise(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Either<Failure, UserProgress>> call(String exerciseId) =>
      _repository.completeExercise(exerciseId);
}
