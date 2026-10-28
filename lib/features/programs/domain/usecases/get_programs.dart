import 'package:calistracker/core/error/failure.dart';
import 'package:calistracker/core/usecases/usecase.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/programs/domain/repositories/programs_repository.dart';
import 'package:dartz/dartz.dart';

class GetPrograms implements UseCase<List<Program>, NoParams> {
  const GetPrograms(this._repository);

  final ProgramsRepository _repository;

  @override
  Future<Either<Failure, List<Program>>> call(NoParams params) =>
      _repository.getPrograms();
}
