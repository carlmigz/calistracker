import 'package:calistracker/core/usecases/usecase.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/programs/domain/usecases/get_programs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'programs_event.dart';
part 'programs_state.dart';

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {
  ProgramsBloc(this._getPrograms) : super(const ProgramsState()) {
    on<ProgramsRequested>(_onRequested);
  }

  final GetPrograms _getPrograms;

  Future<void> _onRequested(
    ProgramsRequested event,
    Emitter<ProgramsState> emit,
  ) async {
    emit(const ProgramsState(status: ProgramsStatus.loading));
    final result = await _getPrograms(const NoParams());
    result.fold(
      (failure) => emit(
        ProgramsState(status: ProgramsStatus.failure, error: failure.message),
      ),
      (programs) => emit(
        ProgramsState(status: ProgramsStatus.success, programs: programs),
      ),
    );
  }
}
