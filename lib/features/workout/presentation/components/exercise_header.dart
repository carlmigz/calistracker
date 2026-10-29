import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Pose on a soft yellow panel, then the target, muscles and description.
class ExerciseHeader extends StatelessWidget {
  const ExerciseHeader({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: PoseImage(asset: exercise.poseAsset, height: 180.h),
          ),
        ),
        SizedBox(height: 14.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          children: [
            _Chip(
              icon: exercise.isHold ? Icons.timer_outlined : Icons.repeat,
              label: exercise.target,
              filled: true,
            ),
            for (final muscle in exercise.muscles) _Chip(label: muscle),
          ],
        ),
        SizedBox(height: 12.h),
        AppCard(
          padding: EdgeInsets.all(14.r),
          child: SizedBox(
            width: double.infinity,
            child: AppText(text: exercise.description, fSize: 13.sp),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.icon, this.filled = false});

  final String label;
  final IconData? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = filled ? scheme.onPrimary : scheme.onSurface;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: filled ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4.w,
        children: [
          if (icon != null) Icon(icon, size: 14.r, color: fg),
          AppText(
            text: label,
            fSize: 12.sp,
            fWeight: filled ? FontWeight.w600 : null,
            textColor: fg,
          ),
        ],
      ),
    );
  }
}
