import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverallProgressCard extends StatelessWidget {
  const OverallProgressCard({
    super.key,
    required this.completed,
    required this.total,
  });

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final value = total == 0 ? 0.0 : completed / total;
    final onPrimary = scheme.onPrimary;

    return AppCard(
      padding: EdgeInsets.all(16.r),
      color: scheme.primary,
      large: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                text: AppStrings.homeYourProgress,
                textColor: onPrimary,
                fWeight: FontWeight.w600,
              ),
              AppText(
                text: '${(value * 100).round()}%',
                fFamily: AppTextStyles.headingFontFamily,
                fSize: 22.sp,
                textColor: onPrimary,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8.h,
              color: onPrimary,
              backgroundColor: onPrimary.withValues(alpha: 0.2),
            ),
          ),
          SizedBox(height: 8.h),
          AppText(
            text: AppStrings.homeExercisesCompleted(completed, total),
            fSize: 12.sp,
            textColor: onPrimary,
          ),
        ],
      ),
    );
  }
}
