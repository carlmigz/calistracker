import 'package:calistracker/core/components/app_toast.dart';
import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/features/progress/domain/entities/achievement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

IconData _iconFor(String id) {
  switch (id) {
    case 'first_step':
      return Icons.flag;
    case 'high_five':
      return Icons.front_hand;
    case 'all_rounder':
      return Icons.apps;
    case 'program_master':
      return Icons.emoji_events;
    case 'streak_3':
      return Icons.local_fire_department;
    case 'streak_7':
      return Icons.bolt;
    default:
      return Icons.star;
  }
}

class BadgeGrid extends StatelessWidget {
  const BadgeGrid({super.key, required this.statuses});

  final List<AchievementStatus> statuses;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10.h,
      crossAxisSpacing: 10.w,
      childAspectRatio: 0.9,
      children: [for (final status in statuses) _BadgeTile(status: status)],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.status});

  final AchievementStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final unlocked = status.unlocked;
    final achievement = status.achievement;

    return AppCard(
      onTap: () => showAppToast(
        context,
        achievement.title,
        type: unlocked ? ToastificationType.success : ToastificationType.info,
        description: unlocked
            ? achievement.description
            : AppStrings.profileBadgeLocked(achievement.description),
      ),
      padding: EdgeInsets.all(8.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: unlocked
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.12),
            foregroundColor: unlocked
                ? scheme.onPrimary
                : scheme.onSurface.withValues(alpha: 0.4),
            child: Icon(unlocked ? _iconFor(achievement.id) : Icons.lock),
          ),
          SizedBox(height: 6.h),
          AppText(
            text: achievement.title,
            fSize: 11.sp,
            fWeight: FontWeight.w600,
            textAlign: TextAlign.center,
            maxLines: 2,
            textColor: unlocked
                ? null
                : scheme.onSurface.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
