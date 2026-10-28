import 'package:calistracker/core/error/failure.dart';
import 'package:calistracker/features/programs/data/datasources/programs_local_datasource.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/programs/domain/repositories/programs_repository.dart';
import 'package:dartz/dartz.dart';

class ProgramsRepositoryImpl implements ProgramsRepository {
  const ProgramsRepositoryImpl(this._local);

  final ProgramsLocalDataSource _local;

  @override
  Future<Either<Failure, List<Program>>> getPrograms() async {
    try {
      return Right(await _local.getPrograms());
    } catch (_) {
      return const Left(ParseFailure());
    }
  }
}
