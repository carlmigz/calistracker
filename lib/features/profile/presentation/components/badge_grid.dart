import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/features/profile/presentation/pages/badge_detail_page.dart';
import 'package:calistracker/features/progress/domain/entities/achievement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

IconData achievementIcon(String id) {
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
    case 'ten_club':
      return Icons.looks_one;
    case 'completionist':
      return Icons.verified;
    case 'streak_14':
      return Icons.whatshot;
    case 'streak_30':
      return Icons.workspace_premium;
    case 'sessions_25':
      return Icons.repeat;
    case 'sessions_100':
      return Icons.military_tech;
    case 'triple_threat':
      return Icons.filter_3;
    case 'power_day':
      return Icons.flash_on;
    case 'active_10':
      return Icons.event_available;
    case 'early_bird':
      return Icons.wb_sunny;
    case 'night_owl':
      return Icons.nightlight_round;
    case 'weekend_warrior':
      return Icons.weekend;
    case 'sigma':
      return Icons.self_improvement;
    case 'giga_chad':
      return Icons.fitness_center;
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
      children: [
        for (var i = 0; i < statuses.length; i++)
          _BadgeTile(
            status: statuses[i],
            onTap: () => BadgeDetailPage.open(context, i),
          ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.status, required this.onTap});

  final AchievementStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final unlocked = status.unlocked;
    final achievement = status.achievement;

    return AppCard(
      onTap: onTap,
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
            child: Icon(
              unlocked ? achievementIcon(achievement.id) : Icons.lock,
            ),
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
