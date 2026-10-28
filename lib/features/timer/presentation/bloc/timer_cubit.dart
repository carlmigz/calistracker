import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum TimerPhase { idle, work, rest, done }

class TimerState extends Equatable {
  const TimerState({
    this.phase = TimerPhase.idle,
    this.workSeconds = 60,
    this.restSeconds = 0,
    this.rounds = 1,
    this.round = 1,
    this.secondsLeft = 60,
    this.phaseTotal = 60,
    this.isRunning = false,
  });

  final TimerPhase phase;
  final int workSeconds;
  final int restSeconds;
  final int rounds;
  final int round;
  final int secondsLeft;
  final int phaseTotal;
  final bool isRunning;

  /// True when no session is in progress, so the settings can be changed.
  bool get isIdle => phase == TimerPhase.idle || phase == TimerPhase.done;

  /// Elapsed part of the current phase, 0..1.
  double get progress => phaseTotal == 0 ? 0 : 1 - secondsLeft / phaseTotal;

  TimerState copyWith({
    TimerPhase? phase,
    int? round,
    int? secondsLeft,
    int? phaseTotal,
    bool? isRunning,
  }) {
    return TimerState(
      phase: phase ?? this.phase,
      workSeconds: workSeconds,
      restSeconds: restSeconds,
      rounds: rounds,
      round: round ?? this.round,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      phaseTotal: phaseTotal ?? this.phaseTotal,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  @override
  List<Object?> get props => [
    phase,
    workSeconds,
    restSeconds,
    rounds,
    round,
    secondsLeft,
    phaseTotal,
    isRunning,
  ];
}

/// Countdown for a single rest (`rest: 0, rounds: 1`) or work/rest intervals.
class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(const TimerState());

  Timer? _timer;

  void configure({required int work, required int rest, required int rounds}) {
    if (!state.isIdle) return;
    _timer?.cancel();
    emit(
      TimerState(
        workSeconds: work,
        restSeconds: rest,
        rounds: rounds,
        secondsLeft: work,
        phaseTotal: work,
      ),
    );
  }

  void start() {
    if (state.isRunning) return;

    if (state.isIdle) {
      emit(
        state.copyWith(
          phase: TimerPhase.work,
          round: 1,
          secondsLeft: state.workSeconds,
          phaseTotal: state.workSeconds,
        ),
      );
    }
    emit(state.copyWith(isRunning: true));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void pause() {
    _timer?.cancel();
    emit(state.copyWith(isRunning: false));
  }

  void reset() {
    _timer?.cancel();
    emit(
      TimerState(
        workSeconds: state.workSeconds,
        restSeconds: state.restSeconds,
        rounds: state.rounds,
        secondsLeft: state.workSeconds,
        phaseTotal: state.workSeconds,
      ),
    );
  }

  void _tick() {
    final left = state.secondsLeft - 1;
    if (left > 0) {
      emit(state.copyWith(secondsLeft: left));
      return;
    }

    HapticFeedback.mediumImpact();

    if (state.phase == TimerPhase.work) {
      if (state.round >= state.rounds) {
        _timer?.cancel();
        emit(
          state.copyWith(
            phase: TimerPhase.done,
            isRunning: false,
            secondsLeft: 0,
          ),
        );
      } else if (state.restSeconds > 0) {
        emit(
          state.copyWith(
            phase: TimerPhase.rest,
            secondsLeft: state.restSeconds,
            phaseTotal: state.restSeconds,
          ),
        );
      } else {
        _startNextRound();
      }
    } else {
      _startNextRound();
    }
  }

  void _startNextRound() {
    emit(
      state.copyWith(
        phase: TimerPhase.work,
        round: state.round + 1,
        secondsLeft: state.workSeconds,
        phaseTotal: state.workSeconds,
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
