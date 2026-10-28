import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({
    super.key,
    required this.exercisesDone,
    required this.streak,
    required this.programsDone,
  });

  final int exercisesDone;
  final int streak;
  final int programsDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.w,
      children: [
        Expanded(
          child: _Stat(
            value: exercisesDone,
            label: 'Exercises',
            icon: Icons.fitness_center,
          ),
        ),
        Expanded(
          child: _Stat(
            value: streak,
            label: 'Day streak',
            icon: Icons.local_fire_department,
          ),
        ),
        Expanded(
          child: _Stat(
            value: programsDone,
            label: 'Programs',
            icon: Icons.emoji_events,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.icon});

  final int value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: scheme.primary),
          SizedBox(height: 4.h),
          AppText(
            text: '$value',
            fFamily: AppTextStyles.headingFontFamily,
            fSize: 20.sp,
          ),
          AppText(text: label, fSize: 11.sp),
        ],
      ),
    );
  }
}
