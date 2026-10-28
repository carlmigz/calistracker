import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:calistracker/features/progress/presentation/components/activity_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Bar chart of the last 7 days; [week] ends with today.
class WeekChart extends StatelessWidget {
  const WeekChart({super.key, required this.week, required this.now});

  final List<int> week;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final maxCount = week.fold(0, (a, b) => a > b ? a : b);

    return AppCard(
      padding: EdgeInsets.all(16.r),
      large: true,
      child: SizedBox(
        height: 130.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < week.length; i++)
              Expanded(
                child: ActivityBar(
                  count: week[i],
                  maxCount: maxCount,
                  label: DateFormat.E().format(UserProgress.dayOf(now, i - 6)),
                  isToday: i == week.length - 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
