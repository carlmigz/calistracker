import 'package:calistracker/core/error/failure.dart';
import 'package:calistracker/features/progress/data/datasources/progress_local_datasource.dart';
import 'package:calistracker/features/progress/domain/entities/completion.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:calistracker/features/progress/domain/repositories/progress_repository.dart';
import 'package:dartz/dartz.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  const ProgressRepositoryImpl(this._local);

  final ProgressLocalDataSource _local;

  @override
  Future<Either<Failure, UserProgress>> getProgress() =>
      _guard(() async => _local.getCompletions());

  @override
  Future<Either<Failure, UserProgress>> completeExercise(String exerciseId) =>
      _guard(() => _local.addCompletion(exerciseId, DateTime.now()));

  @override
  Future<Either<Failure, UserProgress>> resetProgress() => _guard(_local.clear);

  Future<Either<Failure, UserProgress>> _guard(
    Future<List<Completion>> Function() action,
  ) async {
    try {
      return Right(UserProgress(await action()));
    } catch (_) {
      return const Left(StorageFailure());
    }
  }
}
