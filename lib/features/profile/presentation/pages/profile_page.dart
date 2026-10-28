import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:calistracker/features/profile/presentation/components/badge_grid.dart';
import 'package:calistracker/features/profile/presentation/components/profile_header.dart';
import 'package:calistracker/features/profile/presentation/components/settings_section.dart';
import 'package:calistracker/features/profile/presentation/components/stats_row.dart';
import 'package:calistracker/features/progress/domain/entities/achievement.dart';
import 'package:calistracker/features/progress/domain/entities/user_level.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>().state;
    final progress = context.watch<ProgressBloc>().state.progress;
    final programs = context.watch<ProgramsBloc>().state.programs;
    final now = DateTime.now();

    final achievementContext = AchievementContext(
      progress: progress,
      programs: programs,
      now: now,
    );
    final statuses = evaluateAchievements(achievementContext);
    final unlockedCount = statuses.where((s) => s.unlocked).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: AppSizes.bodyPadding,
        children: [
          ProfileHeader(
            name: settings.displayName,
            level: UserLevel.forCompleted(achievementContext.completedCount),
          ),
          SizedBox(height: 20.h),
          StatsRow(
            exercisesDone: achievementContext.completedCount,
            streak: achievementContext.streak,
            programsDone: achievementContext.completedPrograms,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(text: 'Badges', fWeight: FontWeight.bold, fSize: 18.sp),
              AppText(
                text: '$unlockedCount / ${statuses.length}',
                fSize: 12.sp,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          BadgeGrid(statuses: statuses),
          SizedBox(height: 24.h),
          AppText(text: 'Settings', fWeight: FontWeight.bold, fSize: 18.sp),
          SizedBox(height: 12.h),
          SettingsSection(themeMode: settings.themeMode),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
