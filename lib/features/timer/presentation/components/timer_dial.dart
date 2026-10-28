import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/timer/presentation/bloc/timer_cubit.dart';
import 'package:calistracker/features/timer/presentation/components/timer_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The ring plus, for multi-round sessions, one dot per round.
class TimerDial extends StatelessWidget {
  const TimerDial({super.key, required this.state});

  final TimerState state;

  @override
  Widget build(BuildContext context) {
    final showDots =
        state.rounds > 1 &&
        state.rounds <= 12 &&
        state.phase != TimerPhase.idle;

    return Column(
      children: [
        _Dial(state: state),
        if (showDots) ...[SizedBox(height: 16.h), _RoundDots(state: state)],
      ],
    );
  }
}

class _RoundDots extends StatelessWidget {
  const _RoundDots({required this.state});

  final TimerState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final finished = state.phase == TimerPhase.done;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6.w,
      children: [
        for (var round = 1; round <= state.rounds; round++)
          Container(
            width: 10.r,
            height: 10.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: finished || round < state.round
                  ? scheme.primary
                  : round == state.round
                  ? scheme.onSurface
                  : scheme.surfaceContainerHighest,
            ),
          ),
      ],
    );
  }
}

class _Dial extends StatelessWidget {
  const _Dial({required this.state});

  final TimerState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isRest = state.phase == TimerPhase.rest;
    final size = (MediaQuery.sizeOf(context).width * 0.65).clamp(200.0, 300.0);

    final label = switch (state.phase) {
      TimerPhase.idle => AppStrings.timerReady,
      TimerPhase.work => state.rounds > 1 ? AppStrings.work : AppStrings.rest,
      TimerPhase.rest => AppStrings.rest,
      TimerPhase.done => AppStrings.timerDone,
    };
    final seconds = state.phase == TimerPhase.done
        ? 0
        : state.phase == TimerPhase.idle
        ? state.workSeconds
        : state.secondsLeft;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: state.phase == TimerPhase.done ? 1 : state.progress,
              strokeWidth: 10.r,
              strokeCap: StrokeCap.round,
              color: isRest ? scheme.onSurface : scheme.primary,
              backgroundColor: scheme.surfaceContainerHighest,
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: formatClock(seconds),
                    fFamily: AppTextStyles.headingFontFamily,
                    fSize: 44.sp,
                  ),
                  AppText(text: label, fWeight: FontWeight.w600),
                  if (state.rounds > 1 && state.phase != TimerPhase.idle)
                    AppText(
                      text: AppStrings.timerRound(state.round, state.rounds),
                      fSize: 12.sp,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
