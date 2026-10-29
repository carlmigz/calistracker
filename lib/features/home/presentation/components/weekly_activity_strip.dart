import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Last 7 days as dots (oldest first, today last), filled when trained.
class WeeklyActivityStrip extends StatelessWidget {
  const WeeklyActivityStrip({
    super.key,
    required this.activity,
    required this.now,
    required this.weeklyGoal,
  });

  static const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  final List<int> activity;
  final DateTime now;
  final int weeklyGoal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = activity.where((n) => n > 0).length;

    return AppCard(
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: AppStrings.homeThisWeek,
                fSize: 14.sp,
                fWeight: FontWeight.w600,
              ),
              AppText(
                text: AppStrings.homeWeekDays(active, weeklyGoal),
                fSize: 12.sp,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < activity.length; i++)
                _Day(
                  label: _weekdays[UserProgress.dayOf(
                        now,
                        i - (activity.length - 1),
                      ).weekday -
                      1],
                  trained: activity[i] > 0,
                  isToday: i == activity.length - 1,
                  scheme: scheme,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Day extends StatelessWidget {
  const _Day({
    required this.label,
    required this.trained,
    required this.isToday,
    required this.scheme,
  });

  final String label;
  final bool trained;
  final bool isToday;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4.h,
      children: [
        Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: trained ? scheme.primary : Colors.transparent,
            border: Border.all(
              color: trained || isToday
                  ? scheme.primary
                  : scheme.onSurface.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: trained
              ? Icon(Icons.check_rounded, size: 16.r, color: scheme.onPrimary)
              : null,
        ),
        AppText(text: label, fSize: 11.sp),
      ],
    );
  }
}
