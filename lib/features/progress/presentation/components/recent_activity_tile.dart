import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/progress/domain/entities/user_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RecentActivityTile extends StatelessWidget {
  const RecentActivityTile({
    super.key,
    required this.title,
    required this.date,
    required this.now,
  });

  final String title;
  final DateTime date;
  final DateTime now;

  static String _relativeDate(DateTime date, DateTime now) {
    final diff = UserProgress.dayOf(
      now,
    ).difference(UserProgress.dayOf(date)).inDays;
    if (diff == 0) return AppStrings.today;
    if (diff == 1) return AppStrings.yesterday;
    return DateFormat.MMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          child: const Icon(Icons.check),
        ),
        title: AppText(
          text: title,
          fFamily: AppTextStyles.fontFamily,
          fWeight: FontWeight.w600,
        ),
        trailing: AppText(text: _relativeDate(date, now), fSize: 12.sp),
      ),
    );
  }
}
