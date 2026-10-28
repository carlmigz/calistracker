import 'package:calistracker/core/error/failure.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:dartz/dartz.dart';

abstract class ProgramsRepository {
  Future<Either<Failure, List<Program>>> getPrograms();
}
