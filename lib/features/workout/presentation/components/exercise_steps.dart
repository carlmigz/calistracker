import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseSteps extends StatelessWidget {
  const ExerciseSteps({super.key, required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: AppStrings.exerciseHowTo,
          fFamily: AppTextStyles.fontFamily,
          fWeight: FontWeight.bold,
          fSize: 16.sp,
        ),
        SizedBox(height: 10.h),
        AppCard(
          padding: EdgeInsets.all(14.r),
          child: Column(
            spacing: 12.h,
            children: [
              for (final (i, step) in steps.indexed)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.w,
                  children: [
                    CircleAvatar(
                      radius: 12.r,
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      child: AppText(
                        text: '${i + 1}',
                        fSize: 12.sp,
                        fWeight: FontWeight.bold,
                        textColor: scheme.onPrimary,
                      ),
                    ),
                    Expanded(child: AppText(text: step, fSize: 13.sp)),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
