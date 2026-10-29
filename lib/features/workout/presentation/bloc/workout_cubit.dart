import 'dart:async';

import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutState extends Equatable {
  const WorkoutState({
    required this.totalSets,
    this.setsDone = 0,
    this.secondsLeft = 0,
    this.holdTotal = 0,
    this.isHolding = false,
    this.isResting = false,
    this.restLeft = 0,
    this.restTotal = 0,
    this.elapsedSeconds = 0,
  });

  final int totalSets;
  final int setsDone;

  /// Seconds remaining in the current hold; 0 for rep-based exercises.
  final int secondsLeft;
  final int holdTotal;
  final bool isHolding;

  /// Countdown between sets.
  final bool isResting;
  final int restLeft;
  final int restTotal;

  /// Time from the first set to the last one, set when the exercise finishes.
  final int elapsedSeconds;

  bool get isFinished => setsDone >= totalSets;

  /// True while a timer is running, so the set buttons are locked.
  bool get isBusy => isHolding || isResting;

  double get holdProgress =>
      holdTotal == 0 ? 0 : 1 - secondsLeft / holdTotal;

  double get restProgress => restTotal == 0 ? 0 : restLeft / restTotal;

  WorkoutState copyWith({
    int? setsDone,
    int? secondsLeft,
    bool? isHolding,
    bool? isResting,
    int? restLeft,
    int? restTotal,
    int? elapsedSeconds,
  }) {
    return WorkoutState(
      totalSets: totalSets,
      setsDone: setsDone ?? this.setsDone,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      holdTotal: holdTotal,
      isHolding: isHolding ?? this.isHolding,
      isResting: isResting ?? this.isResting,
      restLeft: restLeft ?? this.restLeft,
      restTotal: restTotal ?? this.restTotal,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }

  @override
  List<Object?> get props => [
    totalSets,
    setsDone,
    secondsLeft,
    holdTotal,
    isHolding,
    isResting,
    restLeft,
    restTotal,
    elapsedSeconds,
  ];
}

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit(
    this._exercise, {
    this.restSeconds = 60,
    this.haptics = true,
    this.sound = false,
  }) : super(
         WorkoutState(
           totalSets: _exercise.sets,
           secondsLeft: _exercise.holdSeconds ?? 0,
           holdTotal: _exercise.holdSeconds ?? 0,
         ),
       );

  final Exercise _exercise;

  /// Rest between sets; 0 turns the rest timer off.
  final int restSeconds;
  final bool haptics;
  final bool sound;

  Timer? _timer;
  DateTime? _startedAt;

  void completeSet() {
    if (state.isFinished || state.isBusy) return;
    _startedAt ??= DateTime.now();
    if (haptics) HapticFeedback.lightImpact();
    _finishSet();
  }

  void startHold() {
    final hold = _exercise.holdSeconds;
    if (hold == null || state.isFinished || state.isBusy) return;
    _startedAt ??= DateTime.now();

    emit(state.copyWith(isHolding: true, secondsLeft: hold));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final left = state.secondsLeft - 1;
      if (left <= 0) {
        timer.cancel();
        _feedback();
        _finishSet();
      } else {
        emit(state.copyWith(secondsLeft: left));
      }
    });
  }

  /// Takes back the last finished set (and any rest running after it).
  void undoSet() {
    if (state.setsDone == 0 || state.isHolding) return;
    _timer?.cancel();
    emit(
      state.copyWith(
        setsDone: state.setsDone - 1,
        isResting: false,
        restLeft: 0,
        elapsedSeconds: 0,
      ),
    );
  }

  void skipRest() {
    if (!state.isResting) return;
    _timer?.cancel();
    emit(state.copyWith(isResting: false, restLeft: 0));
  }

  void _finishSet() {
    final done = state.setsDone + 1;
    final reset = _exercise.holdSeconds ?? 0;

    if (done >= state.totalSets) {
      final started = _startedAt ?? DateTime.now();
      emit(
        state.copyWith(
          setsDone: done,
          secondsLeft: reset,
          isHolding: false,
          elapsedSeconds: DateTime.now().difference(started).inSeconds,
        ),
      );
    } else if (restSeconds > 0) {
      emit(
        state.copyWith(
          setsDone: done,
          secondsLeft: reset,
          isHolding: false,
          isResting: true,
          restLeft: restSeconds,
          restTotal: restSeconds,
        ),
      );
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final left = state.restLeft - 1;
        if (left <= 0) {
          timer.cancel();
          _feedback();
          emit(state.copyWith(isResting: false, restLeft: 0));
        } else {
          emit(state.copyWith(restLeft: left));
        }
      });
    } else {
      emit(
        state.copyWith(setsDone: done, secondsLeft: reset, isHolding: false),
      );
    }
  }

  void _feedback() {
    if (haptics) HapticFeedback.mediumImpact();
    if (sound) SystemSound.play(SystemSoundType.alert);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
