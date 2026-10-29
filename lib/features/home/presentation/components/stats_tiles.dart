import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsTiles extends StatelessWidget {
  const StatsTiles({
    super.key,
    required this.sessions,
    required this.exercises,
    required this.activeDays,
  });

  final int sessions;
  final int exercises;
  final int activeDays;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        Expanded(child: _Tile(value: sessions, label: AppStrings.homeSessions)),
        Expanded(
          child: _Tile(value: exercises, label: AppStrings.homeExercisesDone),
        ),
        Expanded(
          child: _Tile(value: activeDays, label: AppStrings.homeActiveDays),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            AppText(
              text: '$value',
              fFamily: AppTextStyles.headingFontFamily,
              fSize: 20.sp,
            ),
            AppText(text: label, fSize: 11.sp),
          ],
        ),
      ),
    );
  }
}
