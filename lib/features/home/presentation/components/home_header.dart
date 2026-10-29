import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/profile/presentation/components/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Mascot avatar with the greeting and the user's display name.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.greeting,
    required this.name,
    required this.avatarColor,
    this.avatarAsset,
  });

  final String greeting;
  final String name;
  final Color avatarColor;
  final String? avatarAsset;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      spacing: 12.w,
      children: [
        ProfileAvatar(size: 52.r, color: avatarColor, asset: avatarAsset),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: greeting,
                fSize: 13.sp,
                textColor: scheme.onSurface.withValues(alpha: 0.7),
              ),
              AppText(
                text: name,
                fFamily: AppTextStyles.headingFontFamily,
                fSize: 20.sp,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppText(
                text: AppStrings.homeReadyToTrain,
                fSize: 12.sp,
                textColor: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
