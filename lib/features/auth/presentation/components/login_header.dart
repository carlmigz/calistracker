import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        PoseImage(height: 140.h),
        SizedBox(height: 16.h),
        AppText(
          text: AppStrings.loginWelcomeBack,
          fFamily: AppTextStyles.headingFontFamily,
          fSize: 24.sp,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        AppText(
          text: AppStrings.loginSubtitle,
          fSize: 13.sp,
          textColor: scheme.onSurface.withValues(alpha: 0.7),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
