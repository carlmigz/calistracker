import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/profile/presentation/components/profile_avatar.dart';
import 'package:calistracker/features/progress/domain/entities/user_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.level,
    required this.avatarColor,
    this.avatarAsset,
    this.memberSince,
  });

  final String name;
  final UserLevel level;
  final Color avatarColor;
  final String? avatarAsset;

  /// Formatted date of the first workout, if there is one.
  final String? memberSince;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ProfileAvatar(size: 104.r, color: avatarColor, asset: avatarAsset),
        SizedBox(height: 12.h),
        AppText(
          text: name,
          fFamily: AppTextStyles.headingFontFamily,
          fSize: 20.sp,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: AppText(
            text: level.name,
            fWeight: FontWeight.w600,
            fSize: 12.sp,
            textColor: scheme.onPrimary,
          ),
        ),
        if (memberSince != null) ...[
          SizedBox(height: 6.h),
          AppText(
            text: AppStrings.profileTrainingSince(memberSince!),
            fSize: 12.sp,
            textColor: scheme.onSurface.withValues(alpha: 0.7),
          ),
        ],
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: () => context.push(AppRoutes.editProfile),
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text(AppStrings.profileEditName),
        ),
      ],
    );
  }
}
