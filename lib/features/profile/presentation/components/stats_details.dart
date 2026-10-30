import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/features/profile/presentation/components/profile_data.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

String _date(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

/// Extra numbers behind the stats page: timeline, week and month comparison,
/// habits, and where the training has gone (programs and muscles).
class StatsDetails extends StatelessWidget {
  const StatsDetails({super.key, required this.data});

  final ProfileData data;

  @override
  Widget build(BuildContext context) {
    final progress = data.progress;
    final now = data.now;
    final counts = progress.dailyCounts;
    final dated = progress.completions.where((c) => c.hasKnownDate).toList();

    int sumDays(int fromOffset, int toOffset) {
      var total = 0;
      for (var i = fromOffset; i <= toOffset; i++) {
        total += counts[UserProgress.dayOf(now, -i)] ?? 0;
      }
      return total;
    }

    final thisWeek = sumDays(0, 6);
    final lastWeek = sumDays(7, 13);
    final thisMonth = dated
        .where(
          (c) =>
              c.completedAt.year == now.year &&
              c.completedAt.month == now.month,
        )
        .length;

    final first = progress.firstWorkout;
    final last = dated.isEmpty
        ? null
        : dated
              .map((c) => c.completedAt)
              .reduce((a, b) => a.isAfter(b) ? a : b);
    final daysSinceStart = first == null
        ? 0
        : UserProgress.dayOf(now).difference(UserProgress.dayOf(first)).inDays +
              1;
    final activeDays = counts.length;
    final consistency = daysSinceStart == 0
        ? 0
        : (activeDays / daysSinceStart * 100).round();
    final average = activeDays == 0
        ? 0.0
        : counts.values.fold(0, (a, b) => a + b) / activeDays;

    final byWeekday = List.filled(7, 0);
    final byPart = {'Morning': 0, 'Afternoon': 0, 'Evening': 0, 'Night': 0};
    for (final c in dated) {
      byWeekday[c.completedAt.weekday - 1]++;
      final h = c.completedAt.hour;
      final part = h >= 5 && h < 12
          ? 'Morning'
          : h >= 12 && h < 17
          ? 'Afternoon'
          : h >= 17 && h < 22
          ? 'Evening'
          : 'Night';
      byPart[part] = byPart[part]! + 1;
    }
    final topWeekday = dated.isEmpty
        ? null
        : _weekdays[byWeekday.indexOf(
            byWeekday.reduce((a, b) => a > b ? a : b),
          )];
    final topPart = dated.isEmpty
        ? null
        : byPart.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

    final muscleOf = {
      for (final p in data.programs)
        for (final e in p.exercises) e.id: e.muscles,
    };
    final programOf = {
      for (final p in data.programs)
        for (final e in p.exercises) e.id: p.name,
    };
    final muscles = <String, int>{};
    final perProgram = <String, int>{};
    for (final c in progress.completions) {
      for (final m in muscleOf[c.exerciseId] ?? const <String>[]) {
        muscles.update(m, (n) => n + 1, ifAbsent: () => 1);
      }
      final name = programOf[c.exerciseId];
      if (name != null) {
        perProgram.update(name, (n) => n + 1, ifAbsent: () => 1);
      }
    }

    final diff = thisWeek - lastWeek;
    final trend = lastWeek == 0 && thisWeek == 0
        ? 'No training in the last two weeks.'
        : diff > 0
        ? 'Up $diff from last week. Keep it going!'
        : diff < 0
        ? 'Down ${-diff} from last week.'
        : 'Same as last week.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Card(
          title: 'Timeline',
          icon: Icons.timeline,
          child: Column(
            children: [
              _Row('First workout', first == null ? 'None yet' : _date(first)),
              _Row('Last workout', last == null ? 'None yet' : _date(last)),
              _Row('Days since you started', '$daysSinceStart'),
              _Row('Active days', '$activeDays'),
              _Row('Consistency', '$consistency% of days'),
            ],
          ),
        ),
        _Card(
          title: 'Recent training',
          icon: Icons.date_range,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Row('Last 7 days', '$thisWeek'),
              _Row('Previous 7 days', '$lastWeek'),
              _Row('This month', '$thisMonth'),
              _Row('Average per active day', average.toStringAsFixed(1)),
              SizedBox(height: 6.h),
              AppText(text: trend, fSize: 12.sp, fWeight: FontWeight.w600),
            ],
          ),
        ),
        _Card(
          title: 'Your habits',
          icon: Icons.schedule,
          child: dated.isEmpty
              ? const _Empty('Finish an exercise to see your habits.')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Row('Favorite day', topWeekday!),
                    _Row('Favorite time', topPart!),
                    SizedBox(height: 10.h),
                    _Bars(
                      entries: [
                        for (var i = 0; i < 7; i++)
                          (_weekdays[i].substring(0, 3), byWeekday[i]),
                      ],
                    ),
                  ],
                ),
        ),
        _Card(
          title: 'Where your training goes',
          icon: Icons.pie_chart_outline,
          child: perProgram.isEmpty
              ? const _Empty('No sessions yet.')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Bars(
                      entries: [
                        for (final e
                            in (perProgram.entries.toList()
                              ..sort((a, b) => b.value.compareTo(a.value))))
                          (e.key, e.value),
                      ],
                      horizontal: true,
                    ),
                    SizedBox(height: 12.h),
                    AppText(
                      text: 'Muscles worked',
                      fSize: 13.sp,
                      fWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 6.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: [
                        for (final e
                            in (muscles.entries.toList()
                              ..sort((a, b) => b.value.compareTo(a.value))))
                          Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text('${e.key} · ${e.value}'),
                          ),
                      ],
                    ),
                  ],
                ),
        ),
        if (progress.completions.any((c) => !c.hasKnownDate))
          AppText(
            text:
                'Some progress was saved before dates were tracked. It counts '
                'toward totals but not toward dates, streaks or habits.',
            fSize: 11.sp,
            textColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.65),
          ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.icon, required this.child});

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: AppCard(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20.r,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                AppText(text: title, fSize: 15.sp, fWeight: FontWeight.bold),
              ],
            ),
            SizedBox(height: 10.h),
            child,
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(text: label, fSize: 13.sp),
          AppText(text: value, fSize: 13.sp, fWeight: FontWeight.bold),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => AppText(
    text: text,
    fSize: 12.sp,
    textColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
  );
}

/// Simple bars: vertical columns by default, or labeled rows.
class _Bars extends StatelessWidget {
  const _Bars({required this.entries, this.horizontal = false});

  final List<(String, int)> entries;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final max = entries.fold(1, (m, e) => e.$2 > m ? e.$2 : m);

    if (horizontal) {
      return Column(
        children: [
          for (final (label, value) in entries)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(text: label, fSize: 12.sp),
                      AppText(
                        text: '$value',
                        fSize: 12.sp,
                        fWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: LinearProgressIndicator(
                      value: value / max,
                      minHeight: 8.h,
                      backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return SizedBox(
      height: 96.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final (label, value) in entries)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppText(text: '$value', fSize: 10.sp),
                  SizedBox(height: 2.h),
                  Container(
                    height: 4.h + 52.h * (value / max),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: value == 0
                          ? scheme.onSurface.withValues(alpha: 0.12)
                          : scheme.primary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  AppText(text: label, fSize: 10.sp),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
