import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrowserEmptyState extends StatelessWidget {
  const BrowserEmptyState({super.key, this.onClear});

  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PoseImage(height: 120.h),
          SizedBox(height: 8.h),
          const AppText(text: AppStrings.workoutsNoMatch),
          if (onClear != null)
            TextButton(
              onPressed: onClear,
              child: const Text(AppStrings.workoutsClearFilters),
            ),
        ],
      ),
    );
  }
}
