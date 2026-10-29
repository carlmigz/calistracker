import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// First-run note shown until the user finishes their first exercise.
class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.all(14.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.w,
        children: [
          Icon(Icons.waving_hand_rounded, color: scheme.primary),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: AppStrings.homeWelcomeTitle,
                  fWeight: FontWeight.w600,
                  fSize: 14.sp,
                ),
                SizedBox(height: 2.h),
                AppText(text: AppStrings.homeWelcomeBody, fSize: 12.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
