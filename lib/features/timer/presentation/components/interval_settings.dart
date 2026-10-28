import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/timer/presentation/components/timer_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntervalSettings extends StatelessWidget {
  const IntervalSettings({
    super.key,
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
    final totalSeconds = (work + rest) * rounds - rest;

    return AppCard(
      padding: EdgeInsets.all(12.r),
      child: Column(
        children: [
          _Stepper(
            label: AppStrings.work,
            value: '${work}s',
            enabled: enabled,
            onMinus: work > 5 ? () => onChanged(work: work - 5) : null,
            onPlus: work < 300 ? () => onChanged(work: work + 5) : null,
          ),
          _Stepper(
            label: AppStrings.rest,
            value: '${rest}s',
            enabled: enabled,
            onMinus: rest > 0 ? () => onChanged(rest: rest - 5) : null,
            onPlus: rest < 300 ? () => onChanged(rest: rest + 5) : null,
          ),
          _Stepper(
            label: AppStrings.timerRounds,
            value: '$rounds',
            enabled: enabled,
            onMinus: rounds > 1 ? () => onChanged(rounds: rounds - 1) : null,
            onPlus: rounds < 30 ? () => onChanged(rounds: rounds + 1) : null,
          ),
          Divider(height: 24.h),
          AppText(
            text: AppStrings.timerTotal(formatClock(totalSeconds)),
            fSize: 12.sp,
            fWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            children: [
              ActionChip(
                label: const Text(AppStrings.timerPresetTabata),
                onPressed: enabled
                    ? () => onChanged(work: 20, rest: 10, rounds: 8)
                    : null,
              ),
              ActionChip(
                label: const Text(AppStrings.timerPresetCircuit),
                onPressed: enabled
                    ? () => onChanged(work: 40, rest: 20, rounds: 5)
                    : null,
              ),
            ],
          ),
        ],
      ),
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
