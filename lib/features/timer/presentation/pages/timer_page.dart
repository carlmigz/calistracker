import 'package:calistracker/core/components/app_button.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/timer/presentation/bloc/timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _TimerMode { rest, interval }

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => TimerCubit(), child: const _TimerView());
  }
}

class _TimerView extends StatefulWidget {
  const _TimerView();

  @override
  State<_TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<_TimerView> {
  static const _restPresets = [30, 60, 90, 120, 180];

  _TimerMode _mode = _TimerMode.rest;
  int _restSeconds = 60;
  int _work = 40;
  int _rest = 20;
  int _rounds = 5;

  void _apply() {
    final cubit = context.read<TimerCubit>();
    if (_mode == _TimerMode.rest) {
      cubit.configure(work: _restSeconds, rest: 0, rounds: 1);
    } else {
      cubit.configure(work: _work, rest: _rest, rounds: _rounds);
    }
  }

  void _setMode(_TimerMode mode) {
    setState(() => _mode = mode);
    _apply();
  }

  void _interval({int? work, int? rest, int? rounds}) {
    setState(() {
      _work = work ?? _work;
      _rest = rest ?? _rest;
      _rounds = rounds ?? _rounds;
    });
    _apply();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: SafeArea(
        child: BlocBuilder<TimerCubit, TimerState>(
          builder: (context, state) {
            final cubit = context.read<TimerCubit>();

            return ListView(
              padding: AppSizes.bodyPadding,
              children: [
                SegmentedButton<_TimerMode>(
                  segments: const [
                    ButtonSegment(
                      value: _TimerMode.rest,
                      label: Text('Rest'),
                      icon: Icon(Icons.hourglass_bottom),
                    ),
                    ButtonSegment(
                      value: _TimerMode.interval,
                      label: Text('Interval'),
                      icon: Icon(Icons.repeat),
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: state.isIdle
                      ? (s) => _setMode(s.first)
                      : null,
                ),
                SizedBox(height: 24.h),
                _Dial(state: state),
                SizedBox(height: 24.h),
                Row(
                  spacing: 12.w,
                  children: [
                    Expanded(
                      child: AppButton(
                        text: state.isRunning
                            ? 'Pause'
                            : state.isIdle
                            ? 'Start'
                            : 'Resume',
                        icon: state.isRunning
                            ? Icons.pause
                            : Icons.play_arrow_rounded,
                        onPressed: state.isRunning ? cubit.pause : cubit.start,
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        text: 'Reset',
                        icon: Icons.refresh,
                        btnColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        iconColor: Theme.of(context).colorScheme.onSurface,
                        onPressed: cubit.reset,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                if (_mode == _TimerMode.rest)
                  _RestPresets(
                    presets: _restPresets,
                    selected: _restSeconds,
                    enabled: state.isIdle,
                    onSelected: (s) {
                      setState(() => _restSeconds = s);
                      _apply();
                    },
                  )
                else
                  _IntervalSettings(
                    work: _work,
                    rest: _rest,
                    rounds: _rounds,
                    enabled: state.isIdle,
                    onChanged: _interval,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

String _format(int seconds) {
  final m = (seconds ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

class _Dial extends StatelessWidget {
  const _Dial({required this.state});

  final TimerState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isRest = state.phase == TimerPhase.rest;

    final label = switch (state.phase) {
      TimerPhase.idle => 'Ready',
      TimerPhase.work => state.rounds > 1 ? 'Work' : 'Rest',
      TimerPhase.rest => 'Rest',
      TimerPhase.done => 'Done!',
    };
    final seconds = state.phase == TimerPhase.done
        ? 0
        : state.phase == TimerPhase.idle
        ? state.workSeconds
        : state.secondsLeft;

    return Center(
      child: SizedBox(
        width: 230.r,
        height: 230.r,
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
                    text: _format(seconds),
                    fFamily: AppTextStyles.headingFontFamily,
                    fSize: 44.sp,
                  ),
                  AppText(text: label, fWeight: FontWeight.w600),
                  if (state.rounds > 1 && state.phase != TimerPhase.idle)
                    AppText(
                      text: 'Round ${state.round} / ${state.rounds}',
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

class _RestPresets extends StatelessWidget {
  const _RestPresets({
    required this.presets,
    required this.selected,
    required this.enabled,
    required this.onSelected,
  });

  final List<int> presets;
  final int selected;
  final bool enabled;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.center,
      children: [
        for (final seconds in presets)
          ChoiceChip(
            showCheckmark: false,
            selected: seconds == selected,
            selectedColor: scheme.primary,
            label: Text(
              seconds >= 60 && seconds % 60 == 0
                  ? '${seconds ~/ 60} min'
                  : '$seconds s',
              style: TextStyle(
                color: seconds == selected
                    ? scheme.onPrimary
                    : scheme.onSurface,
              ),
            ),
            onSelected: enabled ? (_) => onSelected(seconds) : null,
          ),
      ],
    );
  }
}

class _IntervalSettings extends StatelessWidget {
  const _IntervalSettings({
    required this.work,
    required this.rest,
    required this.rounds,
    required this.enabled,
    required this.onChanged,
  });

  final int work;
  final int rest;
  final int rounds;
  final bool enabled;
  final void Function({int? work, int? rest, int? rounds}) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Stepper(
          label: 'Work',
          value: '${work}s',
          enabled: enabled,
          onMinus: work > 5 ? () => onChanged(work: work - 5) : null,
          onPlus: work < 300 ? () => onChanged(work: work + 5) : null,
        ),
        _Stepper(
          label: 'Rest',
          value: '${rest}s',
          enabled: enabled,
          onMinus: rest > 0 ? () => onChanged(rest: rest - 5) : null,
          onPlus: rest < 300 ? () => onChanged(rest: rest + 5) : null,
        ),
        _Stepper(
          label: 'Rounds',
          value: '$rounds',
          enabled: enabled,
          onMinus: rounds > 1 ? () => onChanged(rounds: rounds - 1) : null,
          onPlus: rounds < 30 ? () => onChanged(rounds: rounds + 1) : null,
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          children: [
            ActionChip(
              label: const Text('Tabata 20/10 × 8'),
              onPressed: enabled
                  ? () => onChanged(work: 20, rest: 10, rounds: 8)
                  : null,
            ),
            ActionChip(
              label: const Text('Circuit 40/20 × 5'),
              onPressed: enabled
                  ? () => onChanged(work: 40, rest: 20, rounds: 5)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final String value;
  final bool enabled;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            child: AppText(text: label, fWeight: FontWeight.w600, fSize: 15.sp),
          ),
          IconButton.filledTonal(
            onPressed: enabled ? onMinus : null,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 64.w,
            child: AppText(
              text: value,
              textAlign: TextAlign.center,
              fWeight: FontWeight.bold,
              fSize: 16.sp,
            ),
          ),
          IconButton.filledTonal(
            onPressed: enabled ? onPlus : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
