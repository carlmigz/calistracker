import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One beginner tip per day, rotating through a local list.
class DailyTipCard extends StatelessWidget {
  const DailyTipCard({super.key, required this.now});

  static const tips = [
    'Warm up for a few minutes before you start.',
    'Quality beats quantity: slow, controlled reps build strength.',
    'Rest 60–90 seconds between sets so you can keep good form.',
    'Consistency matters more than intensity. Show up often.',
    'Breathe out on the hard part of every rep.',
    'Sleep and water are part of your training.',
    'Progress to the next exercise only when this one feels easy.',
  ];

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dayOfYear = now.difference(DateTime(now.year)).inDays;

    return AppCard(
      padding: EdgeInsets.all(14.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.w,
        children: [
          Icon(Icons.lightbulb_rounded, color: scheme.primary),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: AppStrings.homeTipOfTheDay,
                  fSize: 12.sp,
                  fWeight: FontWeight.w600,
                ),
                SizedBox(height: 2.h),
                AppText(text: tips[dayOfYear % tips.length], fSize: 13.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
