import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/features/timer/presentation/bloc/timer_cubit.dart';
import 'package:calistracker/features/timer/presentation/components/timer_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Whole-session status: phase, round and time elapsed against the total.
class TimerSessionCard extends StatelessWidget {
  const TimerSessionCard({super.key, required this.state});

  final TimerState state;

  int get _total =>
      state.rounds * state.workSeconds + (state.rounds - 1) * state.restSeconds;

  int get _remaining {
    switch (state.phase) {
      case TimerPhase.idle:
        return _total;
      case TimerPhase.done:
        return 0;
      case TimerPhase.work:
        return state.secondsLeft +
            (state.rounds - state.round) *
                (state.workSeconds + state.restSeconds);
      case TimerPhase.rest:
        return state.secondsLeft +
            (state.rounds - state.round) * state.workSeconds +
            (state.rounds - state.round - 1) * state.restSeconds;
    }
  }

  String get _headline {
    switch (state.phase) {
      case TimerPhase.idle:
        return 'Ready when you are';
      case TimerPhase.done:
        return 'Session complete. Nice work!';
      case TimerPhase.work:
        return state.rounds > 1 ? 'Work' : 'Resting';
      case TimerPhase.rest:
        return 'Rest';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.65);
    final remaining = _remaining.clamp(0, _total);
    final elapsed = _total - remaining;
    final multi = state.rounds > 1;

    return AppCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  text: _headline,
                  fSize: 15.sp,
                  fWeight: FontWeight.bold,
                ),
              ),
              if (multi && state.phase != TimerPhase.idle)
                AppText(
                  text:
                      'Round ${state.phase == TimerPhase.done ? state.rounds : state.round} of ${state.rounds}',
                  fSize: 12.sp,
                  fWeight: FontWeight.w600,
                ),
            ],
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: _total == 0 ? 0 : elapsed / _total,
              minHeight: 8.h,
              backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _Fact(label: 'Total', value: formatClock(_total)),
              _Fact(label: 'Elapsed', value: formatClock(elapsed)),
              _Fact(label: 'Left', value: formatClock(remaining)),
              if (multi) _Fact(label: 'Rounds', value: '${state.rounds}'),
            ],
          ),
          if (multi) ...[
            SizedBox(height: 10.h),
            AppText(
              text:
                  '${state.workSeconds}s work, ${state.restSeconds}s rest, '
                  '${state.rounds} rounds. The last round has no rest after it.',
              fSize: 11.sp,
              textColor: muted,
            ),
          ],
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          AppText(text: value, fSize: 14.sp, fWeight: FontWeight.bold),
          AppText(
            text: label,
            fSize: 10.sp,
            textColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        ],
      ),
    );
  }
}

/// Explains what the selected rest length is good for.
class RestGuideCard extends StatelessWidget {
  const RestGuideCard({super.key, required this.seconds});

  final int seconds;

  static ({String title, String text}) _guide(int s) {
    if (s <= 30) {
      return (
        title: 'Short rest',
        text:
            'Keeps your heart rate up. Good for easy exercises, core work '
            'and building endurance. You may get fewer reps in later sets.',
      );
    }
    if (s <= 60) {
      return (
        title: 'Steady rest',
        text:
            'A good default for beginners. Enough time to catch your breath '
            'and keep a steady rhythm through all your sets.',
      );
    }
    if (s <= 90) {
      return (
        title: 'Balanced rest',
        text:
            'Helps you hold good form on harder variations while still '
            'keeping the session moving.',
      );
    }
    if (s <= 120) {
      return (
        title: 'Strength rest',
        text:
            'Use this for hard progressions and holds, where you want full '
            'strength back for each set.',
      );
    }
    return (
      title: 'Full recovery',
      text:
          'For your hardest sets. Longer rests let you repeat near-maximum '
          'effort. Use it sparingly, since it makes workouts long.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final guide = _guide(seconds);

    return AppCard(
      padding: EdgeInsets.all(16.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.hourglass_bottom, color: scheme.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: '${guide.title} · ${formatClock(seconds)}',
                  fSize: 14.sp,
                  fWeight: FontWeight.bold,
                ),
                SizedBox(height: 4.h),
                AppText(text: guide.text, fSize: 12.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

typedef IntervalTemplate = ({
  String name,
  String note,
  int work,
  int rest,
  int rounds,
});

/// Ready-made interval setups; tapping one fills in the steppers.
class IntervalTemplates extends StatelessWidget {
  const IntervalTemplates({
    super.key,
    required this.enabled,
    required this.onSelected,
  });

  static const templates = <IntervalTemplate>[
    (
      name: 'Beginner',
      note: 'Easy pace to learn the rhythm',
      work: 30,
      rest: 30,
      rounds: 6,
    ),
    (
      name: 'Classic',
      note: 'Steady work with short breaks',
      work: 40,
      rest: 20,
      rounds: 5,
    ),
    (
      name: 'Endurance',
      note: 'Longer effort, quick recovery',
      work: 45,
      rest: 15,
      rounds: 10,
    ),
    (
      name: 'Tabata',
      note: 'Hard 4-minute burst',
      work: 20,
      rest: 10,
      rounds: 8,
    ),
  ];

  final bool enabled;
  final ValueChanged<IntervalTemplate> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: 'Quick setups', fSize: 15.sp, fWeight: FontWeight.bold),
        SizedBox(height: 8.h),
        for (final t in templates)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: AppCard(
              onTap: enabled ? () => onSelected(t) : null,
              padding: EdgeInsets.all(14.r),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: t.name,
                          fSize: 14.sp,
                          fWeight: FontWeight.bold,
                        ),
                        AppText(
                          text: t.note,
                          fSize: 11.sp,
                          textColor: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.65),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        text: '${t.work}s / ${t.rest}s × ${t.rounds}',
                        fSize: 12.sp,
                        fWeight: FontWeight.w600,
                      ),
                      AppText(
                        text: formatClock(
                          t.rounds * t.work + (t.rounds - 1) * t.rest,
                        ),
                        fSize: 11.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Which feedback is on, plus short tips for using the timer well.
class TimerTipsCard extends StatelessWidget {
  const TimerTipsCard({
    super.key,
    required this.haptics,
    required this.sound,
    required this.interval,
  });

  final bool haptics;
  final bool sound;
  final bool interval;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tips = interval
        ? const [
            'Pick work time you can hold with good form to the very end.',
            'Rest is part of the plan. Breathe slowly and shake out your arms.',
            'Start with fewer rounds and add one each week.',
          ]
        : const [
            'Start the timer as soon as a set ends, not after you feel ready.',
            'Rest longer on harder variations and shorter on easy ones.',
            'Your default rest can be changed in Profile, Timer & feedback.',
          ];

    return AppCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 20.r, color: scheme.primary),
              SizedBox(width: 8.w),
              AppText(text: 'Tips', fSize: 15.sp, fWeight: FontWeight.bold),
            ],
          ),
          SizedBox(height: 8.h),
          for (final tip in tips)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: '•  ', fSize: 12.sp),
                  Expanded(
                    child: AppText(text: tip, fSize: 12.sp),
                  ),
                ],
              ),
            ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            children: [
              Chip(
                visualDensity: VisualDensity.compact,
                avatar: Icon(
                  haptics ? Icons.vibration : Icons.phone_android,
                  size: 16.r,
                ),
                label: Text(haptics ? 'Haptics on' : 'Haptics off'),
              ),
              Chip(
                visualDensity: VisualDensity.compact,
                avatar: Icon(
                  sound ? Icons.volume_up : Icons.volume_off,
                  size: 16.r,
                ),
                label: Text(sound ? 'Sound on' : 'Sound off'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
