import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Ring showing exercises finished today against [goal].
class DailyGoalCard extends StatelessWidget {
  const DailyGoalCard({super.key, required this.done, this.goal = 3});

  final int done;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reached = done >= goal;

    return AppCard(
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44.r,
            height: 44.r,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: (done / goal).clamp(0.0, 1.0),
                  strokeWidth: 5.r,
                  color: scheme.primary,
                  backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
                ),
                Center(
                  child: reached
                      ? Icon(Icons.check_rounded, size: 22.r)
                      : AppText(
                          text: '$done',
                          fSize: 14.sp,
                          fWeight: FontWeight.bold,
                        ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          AppText(text: AppStrings.homeDailyGoal, fSize: 12.sp),
          SizedBox(height: 2.h),
          AppText(
            text: AppStrings.homeDailyGoalCount(done.clamp(0, goal), goal),
            fSize: 11.sp,
            textColor: scheme.onSurface.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}
