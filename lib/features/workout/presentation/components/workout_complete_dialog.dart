import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Celebration shown after an exercise is saved. Resolves to true when the
/// user wants to continue with [next].
Future<bool> showWorkoutCompleteDialog(
  BuildContext context, {
  required Exercise exercise,
  required int elapsedSeconds,
  required Exercise? next,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final scheme = Theme.of(context).colorScheme;
      final minutes = elapsedSeconds ~/ 60;
      final seconds = (elapsedSeconds % 60).toString().padLeft(2, '0');

      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PoseImage(asset: exercise.poseAsset, height: 110.h),
            SizedBox(height: 12.h),
            AppText(
              text: AppStrings.exerciseCompleteTitle,
              fFamily: AppTextStyles.headingFontFamily,
              fSize: 18.sp,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            AppText(
              text: exercise.name,
              fWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            AppText(
              text: AppStrings.exerciseTime('$minutes:$seconds'),
              fSize: 12.sp,
              textColor: scheme.onSurface.withValues(alpha: 0.7),
            ),
            if (next == null) ...[
              SizedBox(height: 8.h),
              AppText(
                text: AppStrings.exerciseProgramDone,
                fSize: 12.sp,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.exerciseDone),
          ),
          if (next != null)
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppStrings.exerciseNext(next.name)),
            ),
        ],
      );
    },
  );
  return result ?? false;
}
