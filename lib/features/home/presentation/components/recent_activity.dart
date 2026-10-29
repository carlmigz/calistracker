import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/progress/domain/entities/completion.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Latest completions, newest first. [names] maps exercise id to name.
class RecentActivity extends StatelessWidget {
  const RecentActivity({
    super.key,
    required this.completions,
    required this.names,
    required this.now,
  });

  final List<Completion> completions;
  final Map<String, String> names;
  final DateTime now;

  String _when(DateTime date) {
    final days = UserProgress.dayOf(now)
        .difference(UserProgress.dayOf(date))
        .inDays;
    if (days <= 0) return AppStrings.homeToday;
    if (days == 1) return AppStrings.homeYesterday;
    return AppStrings.homeDaysAgo(days);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
      child: Column(
        children: [
          for (final c in completions)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                spacing: 10.w,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 20.r,
                    color: scheme.primary,
                  ),
                  Expanded(
                    child: AppText(
                      text: names[c.exerciseId] ?? c.exerciseId,
                      fSize: 13.sp,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppText(
                    text: _when(c.completedAt),
                    fSize: 11.sp,
                    textColor: scheme.onSurface.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
