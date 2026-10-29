import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Calendar grid of the last 12 weeks: one column per week (Mon–Sun), darker
/// squares for days with more completions.
class ActivityHeatmap extends StatelessWidget {
  const ActivityHeatmap({super.key, required this.counts, required this.now});

  static const weeks = 12;

  final Map<DateTime, int> counts;
  final DateTime now;

  double _intensity(int count) => switch (count) {
    0 => 0.0,
    1 => 0.4,
    2 => 0.7,
    _ => 1.0,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final today = UserProgress.dayOf(now);
    final thisMonday = UserProgress.dayOf(today, 1 - today.weekday);
    final start = UserProgress.dayOf(thisMonday, -7 * (weeks - 1));
    final gap = 4.r;

    Widget cell(DateTime day) {
      if (day.isAfter(today)) return const SizedBox.shrink();
      final level = _intensity(counts[day] ?? 0);
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: level == 0
              ? scheme.onSurface.withValues(alpha: 0.08)
              : scheme.primary.withValues(alpha: level),
        ),
      );
    }

    return AppCard(
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: AppStrings.profileHeatmapLast,
                fSize: 12.sp,
                textColor: scheme.onSurface.withValues(alpha: 0.7),
              ),
              Row(
                spacing: 3.w,
                children: [
                  AppText(text: AppStrings.profileHeatmapLess, fSize: 10.sp),
                  for (final level in const [0.0, 0.4, 0.7, 1.0])
                    Container(
                      width: 10.r,
                      height: 10.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.r),
                        color: level == 0
                            ? scheme.onSurface.withValues(alpha: 0.08)
                            : scheme.primary.withValues(alpha: level),
                      ),
                    ),
                  AppText(text: AppStrings.profileHeatmapMore, fSize: 10.sp),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            spacing: gap,
            children: [
              for (var w = 0; w < weeks; w++)
                Expanded(
                  child: Column(
                    spacing: gap,
                    children: [
                      for (var d = 0; d < 7; d++)
                        AspectRatio(
                          aspectRatio: 1,
                          child: cell(UserProgress.dayOf(start, w * 7 + d)),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
