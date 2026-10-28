import 'package:calistracker/core/components/section_header.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:calistracker/features/profile/presentation/components/badge_grid.dart';
import 'package:calistracker/features/profile/presentation/components/profile_header.dart';
import 'package:calistracker/features/profile/presentation/components/settings_section.dart';
import 'package:calistracker/features/profile/presentation/components/stats_row.dart';
import 'package:calistracker/features/profile/presentation/components/weekly_goal_card.dart';
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
    final activeDays = progress
        .activityLast7Days(now)
        .where((count) => count > 0)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
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
            bestStreak: progress.longestStreak,
            programsDone: achievementContext.completedPrograms,
          ),
          SizedBox(height: 12.h),
          WeeklyGoalCard(
            activeDays: activeDays,
            goal: settings.weeklyGoal,
            onGoalChanged: context.read<SettingsCubit>().setWeeklyGoal,
          ),
          SectionHeader(
            title: AppStrings.profileBadges,
            trailing: '$unlockedCount / ${statuses.length}',
          ),
          BadgeGrid(statuses: statuses),
          const SectionHeader(title: AppStrings.profileSettings),
          SettingsSection(themeMode: settings.themeMode),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
