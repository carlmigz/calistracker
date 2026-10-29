import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/progress/domain/entities/user_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Current rank, progress to the next one and the achievement count.
class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.level,
    required this.unlockedAchievements,
    required this.totalAchievements,
  });

  final UserLevel level;
  final int unlockedAchievements;
  final int totalAchievements;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.all(14.r),
      child: Row(
        spacing: 12.w,
        children: [
          CircleAvatar(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            child: const Icon(Icons.military_tech_rounded),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: AppStrings.homeLevel(level.name),
                  fSize: 14.sp,
                  fWeight: FontWeight.w600,
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: level.progress,
                    minHeight: 6.h,
                    color: scheme.primary,
                    backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
                  ),
                ),
                SizedBox(height: 4.h),
                AppText(
                  text: level.isMax
                      ? AppStrings.homeMaxLevel
                      : AppStrings.homeToNextLevel(
                          level.remaining,
                          level.nextName!,
                        ),
                  fSize: 11.sp,
                ),
                AppText(
                  text: AppStrings.homeAchievements(
                    unlockedAchievements,
                    totalAchievements,
                  ),
                  fSize: 11.sp,
                  textColor: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
