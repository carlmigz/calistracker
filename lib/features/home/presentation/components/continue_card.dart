import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Up next" shortcut. Pass a null [exercise] when everything is done.
class ContinueCard extends StatelessWidget {
  const ContinueCard({
    super.key,
    required this.exercise,
    required this.programName,
    required this.onTap,
  });

  final Exercise? exercise;
  final String programName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final next = exercise;

    return AppCard(
      large: true,
      onTap: next == null ? null : onTap,
      padding: EdgeInsets.all(12.r),
      child: Row(
        spacing: 12.w,
        children: [
          PoseImage(asset: next?.poseAsset, height: 64.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: next == null
                      ? AppStrings.homeAllDone
                      : AppStrings.homeUpNext(programName),
                  fSize: 11.sp,
                ),
                SizedBox(height: 2.h),
                AppText(
                  text: next?.name ?? AppStrings.homeFinishedEverything,
                  fFamily: AppTextStyles.fontFamily,
                  fWeight: FontWeight.bold,
                  fSize: 16.sp,
                ),
                if (next != null) AppText(text: next.target, fSize: 12.sp),
              ],
            ),
          ),
          if (next != null)
            CircleAvatar(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              child: const Icon(Icons.play_arrow_rounded),
            ),
        ],
      ),
    );
  }
}
