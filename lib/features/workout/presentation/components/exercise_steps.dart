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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: AppStrings.exerciseHowTo,
          fFamily: AppTextStyles.fontFamily,
          fWeight: FontWeight.bold,
          fSize: 16.sp,
        ),
        SizedBox(height: 4.h),
        for (final (i, step) in steps.indexed)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: AppText(text: '${i + 1}. $step'),
          ),
      ],
    );
  }
}
