import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseHeader extends StatelessWidget {
  const ExerciseHeader({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: PoseImage(asset: exercise.poseAsset, height: 200.h),
        ),
        SizedBox(height: 12.h),
        AppText(text: exercise.description),
        SizedBox(height: 4.h),
        AppText(
          text: AppStrings.exerciseTarget(
            exercise.target,
            exercise.muscles.join(', '),
          ),
          fSize: 12.sp,
        ),
      ],
    );
  }
}
