import 'package:calistracker/core/error/failure.dart';
import 'package:calistracker/core/usecases/usecase.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:calistracker/features/progress/domain/usecases/complete_exercise.dart';
import 'package:calistracker/features/progress/domain/usecases/get_progress.dart';
import 'package:calistracker/features/progress/domain/usecases/reset_progress.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'progress_event.dart';
part 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc(this._getProgress, this._completeExercise, this._resetProgress)
    : super(const ProgressState()) {
    on<ProgressRequested>((event, emit) async {
      _emitResult(emit, await _getProgress(const NoParams()));
    });
    on<ExerciseCompleted>((event, emit) async {
      _emitResult(emit, await _completeExercise(event.exerciseId));
    });
    on<ProgressReset>((event, emit) async {
      _emitResult(emit, await _resetProgress(const NoParams()));
    });
  }

  final GetProgress _getProgress;
  final CompleteExercise _completeExercise;
  final ResetProgress _resetProgress;

  void _emitResult(
    Emitter<ProgressState> emit,
    Either<Failure, UserProgress> result,
  ) {
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (progress) => emit(ProgressState(progress: progress)),
    );
  }
}
