import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key, required this.current, required this.best});

  final int current;
  final int best;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 28.r,
            color: current > 0
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.4),
          ),
          SizedBox(height: 6.h),
          AppText(
            text: '$current',
            fFamily: AppTextStyles.headingFontFamily,
            fSize: 24.sp,
          ),
          AppText(text: AppStrings.homeStreak, fSize: 12.sp),
          SizedBox(height: 2.h),
          AppText(
            text: AppStrings.homeBestStreak(best),
            fSize: 11.sp,
            textColor: scheme.onSurface.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}
