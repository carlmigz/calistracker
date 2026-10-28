import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/features/timer/presentation/bloc/timer_cubit.dart';
import 'package:calistracker/features/timer/presentation/components/interval_settings.dart';
import 'package:calistracker/features/timer/presentation/components/rest_presets.dart';
import 'package:calistracker/features/timer/presentation/components/timer_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _TimerMode { rest, interval }

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => TimerCubit(), child: const _TimerView());
  }
}

class _TimerView extends HookWidget {
  const _TimerView();

  static const _restPresets = [30, 60, 90, 120, 180];

  @override
  Widget build(BuildContext context) {
    final mode = useState(_TimerMode.rest);
    final restSeconds = useState(60);
    final intervalWork = useState(40);
    final intervalRest = useState(20);
    final intervalRounds = useState(5);

    void apply() {
      final cubit = context.read<TimerCubit>();
      if (mode.value == _TimerMode.rest) {
        cubit.configure(work: restSeconds.value, rest: 0, rounds: 1);
      } else {
        cubit.configure(
          work: intervalWork.value,
          rest: intervalRest.value,
          rounds: intervalRounds.value,
        );
      }
    }

    void setInterval({int? work, int? rest, int? rounds}) {
      intervalWork.value = work ?? intervalWork.value;
      intervalRest.value = rest ?? intervalRest.value;
      intervalRounds.value = rounds ?? intervalRounds.value;
      apply();
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navTimer)),
      body: SafeArea(
        child: BlocBuilder<TimerCubit, TimerState>(
          buildWhen: (a, b) => a.phase != b.phase || a.isRunning != b.isRunning,
          builder: (context, state) {
            final cubit = context.read<TimerCubit>();

            return ListView(
              padding: AppSizes.bodyPadding,
              children: [
                SegmentedButton<_TimerMode>(
                  segments: const [
                    ButtonSegment(
                      value: _TimerMode.rest,
                      label: Text(AppStrings.rest),
                      icon: Icon(Icons.hourglass_bottom),
                    ),
                    ButtonSegment(
                      value: _TimerMode.interval,
                      label: Text(AppStrings.timerInterval),
                      icon: Icon(Icons.repeat),
                    ),
                  ],
                  selected: {mode.value},
                  onSelectionChanged: state.isIdle
                      ? (s) {
                          mode.value = s.first;
                          apply();
                        }
                      : null,
                ),
                SizedBox(height: 24.h),
                BlocBuilder<TimerCubit, TimerState>(
                  builder: (context, tick) => TimerDial(state: tick),
                ),
                SizedBox(height: 24.h),
                Row(
                  spacing: 12.w,
                  children: [
                    Expanded(
                      child: AppButton(
                        text: state.isRunning
                            ? AppStrings.timerPause
                            : state.isIdle
                            ? AppStrings.timerStart
                            : AppStrings.timerResume,
                        icon: state.isRunning
                            ? Icons.pause
                            : Icons.play_arrow_rounded,
                        onPressed: state.isRunning ? cubit.pause : cubit.start,
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        text: AppStrings.reset,
                        icon: Icons.refresh,
                        btnColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        iconColor: Theme.of(context).colorScheme.onSurface,
                        onPressed: state.phase == TimerPhase.idle
                            ? null
                            : cubit.reset,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                if (mode.value == _TimerMode.rest)
                  RestPresets(
                    presets: _restPresets,
                    selected: restSeconds.value,
                    enabled: state.isIdle,
                    onSelected: (s) {
                      restSeconds.value = s;
                      apply();
                    },
                  )
                else
                  IntervalSettings(
                    work: intervalWork.value,
                    rest: intervalRest.value,
                    rounds: intervalRounds.value,
                    enabled: state.isIdle,
                    onChanged: setInterval,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
