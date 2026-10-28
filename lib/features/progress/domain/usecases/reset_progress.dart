import 'package:calistracker/core/error/failure.dart';
import 'package:calistracker/core/usecases/usecase.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:calistracker/features/progress/domain/repositories/progress_repository.dart';
import 'package:dartz/dartz.dart';

class ResetProgress implements UseCase<UserProgress, NoParams> {
  const ResetProgress(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Either<Failure, UserProgress>> call(NoParams params) =>
      _repository.resetProgress();
}
