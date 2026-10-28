import 'dart:async';

import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutState extends Equatable {
  const WorkoutState({
    required this.totalSets,
    this.setsDone = 0,
    this.secondsLeft = 0,
    this.isHolding = false,
  });

  final int totalSets;
  final int setsDone;

  /// Seconds remaining in the current hold; 0 for rep-based exercises.
  final int secondsLeft;
  final bool isHolding;

  bool get isFinished => setsDone >= totalSets;

  WorkoutState copyWith({int? setsDone, int? secondsLeft, bool? isHolding}) {
    return WorkoutState(
      totalSets: totalSets,
      setsDone: setsDone ?? this.setsDone,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      isHolding: isHolding ?? this.isHolding,
    );
  }

  @override
  List<Object?> get props => [totalSets, setsDone, secondsLeft, isHolding];
}

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit(this._exercise)
    : super(
        WorkoutState(
          totalSets: _exercise.sets,
          secondsLeft: _exercise.holdSeconds ?? 0,
        ),
      );

  final Exercise _exercise;
  Timer? _timer;

  void completeSet() {
    if (state.isFinished || state.isHolding) return;
    emit(state.copyWith(setsDone: state.setsDone + 1));
  }

  void startHold() {
    final hold = _exercise.holdSeconds;
    if (hold == null || state.isFinished || state.isHolding) return;

    emit(state.copyWith(isHolding: true, secondsLeft: hold));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final left = state.secondsLeft - 1;
      if (left <= 0) {
        timer.cancel();
        emit(
          state.copyWith(
            setsDone: state.setsDone + 1,
            secondsLeft: hold,
            isHolding: false,
          ),
        );
      } else {
        emit(state.copyWith(secondsLeft: left));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
