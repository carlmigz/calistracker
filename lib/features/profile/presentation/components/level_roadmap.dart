import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/progress/domain/entities/user_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Where the user stands, then every rank tier with what it means and what to
/// do next. Reached tiers are filled in.
class LevelRoadmap extends StatelessWidget {
  const LevelRoadmap({
    super.key,
    required this.completed,
    required this.totalExercises,
    required this.sessions,
    required this.bestStreak,
  });

  final int completed;
  final int totalExercises;
  final int sessions;
  final int bestStreak;

  @override
  Widget build(BuildContext context) {
    final tiers = UserLevel.tiers;
    final level = UserLevel.forCompleted(completed);
    final currentIndex = tiers.indexWhere((t) => t.name == level.name);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Summary(
          level: level,
          completed: completed,
          totalExercises: totalExercises,
          sessions: sessions,
          bestStreak: bestStreak,
        ),
        SizedBox(height: 20.h),
        AppText(text: 'All ranks', fWeight: FontWeight.bold, fSize: 16.sp),
        SizedBox(height: 10.h),
        for (var i = 0; i < tiers.length; i++)
          _TierRow(
            name: tiers[i].name,
            requirement: AppStrings.profileRoadmapAt(tiers[i].at),
            about: tiers[i].about,
            focus: tiers[i].focus,
            reached: completed >= tiers[i].at,
            isCurrent: i == currentIndex,
            remaining: tiers[i].at - completed,
            isLast: i == tiers.length - 1,
          ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.level,
    required this.completed,
    required this.totalExercises,
    required this.sessions,
    required this.bestStreak,
  });

  final UserLevel level;
  final int completed;
  final int totalExercises;
  final int sessions;
  final int bestStreak;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.6);
    final overall = totalExercises == 0
        ? 0
        : (completed / totalExercises * 100).round().clamp(0, 100);

    return AppCard(
      large: true,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(text: 'Your rank', fSize: 12.sp, textColor: muted),
          SizedBox(height: 2.h),
          AppText(text: level.name, fSize: 26.sp, fWeight: FontWeight.bold),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: level.progress,
              minHeight: 10.h,
              backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
            ),
          ),
          SizedBox(height: 8.h),
          AppText(
            text: level.isMax
                ? AppStrings.profileTopLevel
                : '${AppStrings.profileMoreToLevel(level.remaining, level.nextName)} '
                      '(${(level.progress * 100).round()}% of this rank)',
            fSize: 12.sp,
            textColor: muted,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _Stat(label: 'Exercises', value: '$completed / $totalExercises'),
              _Stat(label: 'Sessions', value: '$sessions'),
              _Stat(label: 'Best streak', value: '$bestStreak d'),
              _Stat(label: 'Overall', value: '$overall%'),
            ],
          ),
          SizedBox(height: 12.h),
          AppText(
            text:
                'Your rank counts the different exercises you have completed. '
                'Repeating an exercise adds sessions but not rank.',
            fSize: 12.sp,
            textColor: muted,
          ),
        ],
      ),
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
          AppText(text: value, fWeight: FontWeight.bold, fSize: 14.sp),
          SizedBox(height: 2.h),
          AppText(
            text: label,
            fSize: 10.sp,
            textAlign: TextAlign.center,
            textColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({
    required this.name,
    required this.requirement,
    required this.about,
    required this.focus,
    required this.reached,
    required this.isCurrent,
    required this.remaining,
    required this.isLast,
  });

  final String name;
  final String requirement;
  final String about;
  final String focus;
  final bool reached;
  final bool isCurrent;
  final int remaining;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.5);
    final status = isCurrent
        ? 'You are here'
        : reached
        ? 'Reached'
        : '$remaining to go';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12.w,
        children: [
          Column(
            children: [
              SizedBox(height: 14.h),
              Container(
                width: 22.r,
                height: 22.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: reached ? scheme.primary : Colors.transparent,
                  border: Border.all(
                    color: reached ? scheme.primary : muted,
                    width: 2,
                  ),
                ),
                child: reached
                    ? Icon(Icons.check, size: 14.r, color: scheme.onPrimary)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: reached ? scheme.primary : muted,
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: AppCard(
                padding: EdgeInsets.all(14.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText(
                            text: name,
                            fWeight: FontWeight.bold,
                            fSize: 15.sp,
                            textColor: reached ? null : muted,
                          ),
                        ),
                        AppText(
                          text: requirement,
                          fSize: 12.sp,
                          textColor: reached ? null : muted,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    AppText(
                      text: status,
                      fSize: 11.sp,
                      fWeight: FontWeight.w600,
                      textColor: isCurrent ? scheme.primary : muted,
                    ),
                    SizedBox(height: 8.h),
                    AppText(text: about, fSize: 12.sp),
                    SizedBox(height: 8.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 14.r,
                          color: scheme.primary,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: AppText(text: focus, fSize: 12.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
