import 'package:calistracker/core/components/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityBar extends StatelessWidget {
  const ActivityBar({
    super.key,
    required this.count,
    required this.maxCount,
    required this.label,
    required this.isToday,
  });

  final int count;
  final int maxCount;
  final String label;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fraction = maxCount == 0 ? 0.0 : count / maxCount;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppText(text: count == 0 ? '' : '$count', fSize: 11.sp),
        SizedBox(height: 4.h),
        Flexible(
          child: FractionallySizedBox(
            heightFactor: fraction.clamp(0.04, 1.0),
            child: Container(
              width: 18.w,
              decoration: BoxDecoration(
                color: count == 0
                    ? scheme.onSurface.withValues(alpha: 0.15)
                    : scheme.primary,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        AppText(
          text: label,
          fSize: 11.sp,
          fWeight: isToday ? FontWeight.bold : FontWeight.normal,
        ),
      ],
    );
  }
}
