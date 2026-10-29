import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalRecords extends StatelessWidget {
  const PersonalRecords({
    super.key,
    required this.bestDay,
    required this.sessions,
    required this.activeDays,
    required this.longestStreak,
  });

  final int bestDay;
  final int sessions;
  final int activeDays;
  final int longestStreak;

  @override
  Widget build(BuildContext context) {
    final records = [
      (Icons.whatshot_rounded, bestDay, AppStrings.profileRecordBestDay),
      (Icons.repeat_rounded, sessions, AppStrings.profileRecordSessions),
      (Icons.event_available_rounded, activeDays, AppStrings.profileRecordActiveDays),
      (Icons.bolt_rounded, longestStreak, AppStrings.profileRecordLongest),
    ];
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.all(14.r),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 2.6,
        children: [
          for (final (icon, value, label) in records)
            Row(
              spacing: 10.w,
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  child: Icon(icon, size: 18.r),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: '$value',
                        fFamily: AppTextStyles.headingFontFamily,
                        fSize: 16.sp,
                      ),
                      AppText(
                        text: label,
                        fSize: 11.sp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
