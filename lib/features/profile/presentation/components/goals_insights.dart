import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/features/profile/presentation/components/profile_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _weekdayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

/// Today's status, the week at a glance and how the goals have gone so far.
class GoalsInsights extends StatelessWidget {
  const GoalsInsights({super.key, required this.data});

  final ProfileData data;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.65);
    final dailyGoal = data.settings.dailyGoal;
    final weeklyGoal = data.settings.weeklyGoal;
    final week = data.progress.activityLast7Days(data.now);
    final counts = data.progress.dailyCounts;

    final today = data.doneToday;
    final left = (dailyGoal - today).clamp(0, dailyGoal);
    final goalDaysThisWeek = week.where((n) => n >= dailyGoal).length;
    final goalDaysEver = counts.values.where((n) => n >= dailyGoal).length;
    final weekTotal = week.fold(0, (a, b) => a + b);
    final activeDays = counts.length;
    final average = activeDays == 0
        ? 0.0
        : counts.values.fold(0, (a, b) => a + b) / activeDays;
    final weeklyTarget = dailyGoal * weeklyGoal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          large: true,
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              SizedBox(
                width: 72.r,
                height: 72.r,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: (today / dailyGoal).clamp(0.0, 1.0),
                      strokeWidth: 8,
                      backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
                    ),
                    Center(
                      child: AppText(
                        text: '$today/$dailyGoal',
                        fWeight: FontWeight.bold,
                        fSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: left == 0 ? 'Daily goal reached!' : "Today's goal",
                      fSize: 16.sp,
                      fWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 4.h),
                    AppText(
                      text: left == 0
                          ? 'You finished $today exercise${today == 1 ? '' : 's'} today. Anything extra is a bonus.'
                          : '$left more exercise${left == 1 ? '' : 's'} to hit your goal today.',
                      fSize: 12.sp,
                      textColor: muted,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        AppCard(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'Last 7 days',
                fSize: 15.sp,
                fWeight: FontWeight.bold,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  for (var i = 0; i < 7; i++)
                    Expanded(
                      child: _DayDot(
                        letter:
                            _weekdayLetters[data.now
                                    .subtract(Duration(days: 6 - i))
                                    .weekday -
                                1],
                        count: week[i],
                        goal: dailyGoal,
                        isToday: i == 6,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10.h),
              AppText(
                text:
                    '$goalDaysThisWeek of 7 days reached the daily goal. '
                    '${data.activeDaysThisWeek} active, '
                    'weekly goal is $weeklyGoal.',
                fSize: 12.sp,
                textColor: muted,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        AppCard(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'Goal stats',
                fSize: 15.sp,
                fWeight: FontWeight.bold,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _Stat(label: 'This week', value: '$weekTotal'),
                  _Stat(label: 'Weekly target', value: '$weeklyTarget'),
                  _Stat(label: 'Goal days', value: '$goalDaysEver'),
                  _Stat(
                    label: 'Avg / active day',
                    value: average.toStringAsFixed(1),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              AppText(
                text:
                    'Weekly target = daily goal × weekly goal '
                    '($dailyGoal × $weeklyGoal). Best day ever: '
                    '${data.progress.bestDayCount}.',
                fSize: 11.sp,
                textColor: muted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Suggestions for picking a sensible goal and how the two goals fit together.
class GoalsAdvice extends StatelessWidget {
  const GoalsAdvice({
    super.key,
    required this.dailyGoal,
    required this.weeklyGoal,
  });

  final int dailyGoal;
  final int weeklyGoal;

  String get _assessment {
    if (weeklyGoal >= 7) {
      return 'Training every day leaves no rest day. Consider 5 or 6 days so your body can recover.';
    }
    if (dailyGoal >= 6) {
      return 'That is a big day. Spread the work out and keep your form clean.';
    }
    if (dailyGoal <= 2 && weeklyGoal <= 3) {
      return 'A gentle plan, great for building the habit. Raise it once it feels easy.';
    }
    return 'A balanced plan. Stay consistent for a few weeks before changing it.';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const tips = [
      'Beginners: 1 to 2 exercises a day, 3 days a week.',
      'Regular: 3 exercises a day, 4 to 5 days a week.',
      'Rest days matter. Muscles grow while you recover.',
      'Small goals you always hit beat big goals you skip.',
    ];

    return AppCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates_outlined, color: scheme.primary),
              SizedBox(width: 8.w),
              AppText(
                text: 'Choosing your goals',
                fSize: 15.sp,
                fWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          AppText(text: _assessment, fSize: 13.sp, fWeight: FontWeight.w600),
          SizedBox(height: 8.h),
          for (final tip in tips)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
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
          SizedBox(height: 8.h),
          AppText(
            text:
                'The daily goal counts exercises finished in a day. The '
                'weekly goal counts days with at least one exercise.',
            fSize: 11.sp,
            textColor: scheme.onSurface.withValues(alpha: 0.65),
          ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.letter,
    required this.count,
    required this.goal,
    required this.isToday,
  });

  final String letter;
  final int count;
  final int goal;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reached = count >= goal;
    final active = count > 0;

    return Column(
      children: [
        AppText(
          text: letter,
          fSize: 11.sp,
          fWeight: isToday ? FontWeight.bold : FontWeight.w500,
        ),
        SizedBox(height: 6.h),
        Container(
          width: 28.r,
          height: 28.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: reached
                ? scheme.primary
                : active
                ? scheme.primary.withValues(alpha: 0.3)
                : Colors.transparent,
            border: Border.all(
              color: isToday
                  ? scheme.onSurface
                  : scheme.onSurface.withValues(alpha: 0.2),
              width: isToday ? 2 : 1,
            ),
          ),
          child: reached
              ? Icon(Icons.check, size: 16.r, color: scheme.onPrimary)
              : active
              ? AppText(text: '$count', fSize: 11.sp, fWeight: FontWeight.bold)
              : null,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          AppText(text: value, fSize: 16.sp, fWeight: FontWeight.bold),
          SizedBox(height: 2.h),
          AppText(
            text: label,
            fSize: 10.sp,
            textAlign: TextAlign.center,
            textColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        ],
      ),
    );
  }
}
