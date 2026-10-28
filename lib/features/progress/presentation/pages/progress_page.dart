import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  static String _relativeDate(DateTime date, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat.MMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressBloc>().state.progress;
    final programs = context.watch<ProgramsBloc>().state;
    final now = DateTime.now();
    final scheme = Theme.of(context).colorScheme;

    final week = progress.activityLast7Days(now);
    final maxCount = week.fold(0, (a, b) => a > b ? a : b);
    final recent = progress.recent(10);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: AppSizes.bodyPadding,
        children: [
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department,
                  value: '${progress.currentStreak(now)}',
                  label: 'Day streak',
                  highlighted: true,
                ),
              ),
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle_outline,
                  value: '${progress.completions.length}',
                  label: 'Sessions done',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          AppText(text: 'This week', fWeight: FontWeight.bold, fSize: 18.sp),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: SizedBox(
              height: 130.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < week.length; i++)
                    Expanded(
                      child: _Bar(
                        count: week[i],
                        maxCount: maxCount,
                        label: DateFormat.E().format(
                          DateTime(now.year, now.month, now.day - (6 - i)),
                        ),
                        isToday: i == week.length - 1,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          AppText(
            text: 'Recent activity',
            fWeight: FontWeight.bold,
            fSize: 18.sp,
          ),
          SizedBox(height: 12.h),
          if (recent.isEmpty)
            Column(
              children: [
                PoseImage(height: 120.h),
                SizedBox(height: 8.h),
                const AppText(
                  text: 'Finish an exercise and it will show up here.',
                  textAlign: TextAlign.center,
                ),
              ],
            )
          else
            for (final completion in recent)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  tileColor: scheme.surfaceContainerHighest,
                  leading: CircleAvatar(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    child: const Icon(Icons.check),
                  ),
                  title: AppText(
                    text:
                        programs.findExercise(completion.exerciseId)?.name ??
                        completion.exerciseId,
                    fFamily: AppTextStyles.fontFamily,
                    fWeight: FontWeight.w600,
                  ),
                  trailing: AppText(
                    text: _relativeDate(completion.completedAt, now),
                    fSize: 12.sp,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.highlighted = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = highlighted ? scheme.onPrimary : scheme.onSurface;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: highlighted ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: foreground),
          SizedBox(height: 8.h),
          AppText(
            text: value,
            fFamily: AppTextStyles.headingFontFamily,
            fSize: 28.sp,
            textColor: foreground,
          ),
          AppText(text: label, fSize: 12.sp, textColor: foreground),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.count,
    required this.maxCount,
    required this.label,
    required this.isToday,
  });

  final int count;
  final int maxCount;
  final String label;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fraction = maxCount == 0 ? 0.0 : count / maxCount;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppText(text: count == 0 ? '' : '$count', fSize: 11.sp),
        SizedBox(height: 4.h),
        Flexible(
          child: FractionallySizedBox(
            heightFactor: fraction.clamp(0.04, 1.0),
            child: Container(
              width: 18.w,
              decoration: BoxDecoration(
                color: count == 0
                    ? scheme.onSurface.withValues(alpha: 0.15)
                    : scheme.primary,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        AppText(
          text: label,
          fSize: 11.sp,
          fWeight: isToday ? FontWeight.bold : FontWeight.normal,
        ),
      ],
    );
  }
}
