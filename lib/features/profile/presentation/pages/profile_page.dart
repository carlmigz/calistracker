import 'package:calistracker/core/components/section_header.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/session/app_session.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:calistracker/features/profile/presentation/components/activity_heatmap.dart';
import 'package:calistracker/features/profile/presentation/components/badge_grid.dart';
import 'package:calistracker/features/profile/presentation/components/daily_goal_setting.dart';
import 'package:calistracker/features/profile/presentation/components/level_roadmap.dart';
import 'package:calistracker/features/profile/presentation/components/personal_records.dart';
import 'package:calistracker/features/profile/presentation/components/preference_cards.dart';
import 'package:calistracker/features/profile/presentation/components/profile_actions.dart';
import 'package:calistracker/features/profile/presentation/components/profile_data.dart';
import 'package:calistracker/features/profile/presentation/components/profile_header.dart';
import 'package:calistracker/features/profile/presentation/components/profile_section_page.dart';
import 'package:calistracker/features/profile/presentation/components/profile_tile_group.dart';
import 'package:calistracker/features/profile/presentation/components/program_progress_list.dart';
import 'package:calistracker/features/profile/presentation/components/stats_row.dart';
import 'package:calistracker/features/profile/presentation/components/weekly_goal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Profile overview: header plus a menu of list tiles. Each tile opens its own
/// page (see [ProfileSectionPage]) so the screen stays short.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static String _themeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.system => AppStrings.settingsThemeSystem,
    ThemeMode.light => AppStrings.settingsThemeLight,
    ThemeMode.dark => AppStrings.settingsThemeDark,
  };

  @override
  Widget build(BuildContext context) {
    final data = ProfileData.watch(context);
    final settings = data.settings;
    final progress = data.progress;
    final first = progress.firstWorkout;

    void open(String title, WidgetBuilder builder) =>
        ProfileSectionPage.open(context, title: title, builder: builder);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: ListView(
        padding: AppSizes.bodyPadding,
        children: [
          ProfileHeader(
            name: settings.displayName,
            level: data.level,
            avatarColor: settings.avatarColor,
            avatarAsset: settings.avatarPose,
            memberSince: first == null
                ? null
                : DateFormat.yMMMd().format(first),
          ),
          const SectionHeader(title: AppStrings.profileGroupProgress),
          ProfileTileGroup(
            tiles: [
              ProfileTile(
                icon: Icons.insights_rounded,
                title: AppStrings.profileStatsRecords,
                subtitle: AppStrings.profileStatsSubtitle(
                  data.completedCount,
                  progress.longestStreak,
                ),
                onTap: () => open(AppStrings.profileStatsRecords, (context) {
                  final d = ProfileData.watch(context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StatsRow(
                        exercisesDone: d.completedCount,
                        streak: d.achievementContext.streak,
                        bestStreak: d.progress.longestStreak,
                        programsDone: d.achievementContext.completedPrograms,
                      ),
                      const SectionHeader(title: AppStrings.profileRecords),
                      PersonalRecords(
                        bestDay: d.progress.bestDayCount,
                        sessions: d.progress.completions.length,
                        activeDays: d.progress.dailyCounts.length,
                        longestStreak: d.progress.longestStreak,
                      ),
                    ],
                  );
                }),
              ),
              ProfileTile(
                icon: Icons.calendar_view_month_rounded,
                title: AppStrings.profileHeatmap,
                subtitle: AppStrings.profileHeatmapSubtitle,
                onTap: () => open(AppStrings.profileHeatmap, (context) {
                  final d = ProfileData.watch(context);
                  return ActivityHeatmap(
                    counts: d.progress.dailyCounts,
                    now: d.now,
                  );
                }),
              ),
              ProfileTile(
                icon: Icons.military_tech_rounded,
                title: AppStrings.profileRoadmap,
                subtitle: AppStrings.profileRoadmapSubtitle(data.level.name),
                onTap: () => open(
                  AppStrings.profileRoadmap,
                  (context) => LevelRoadmap(
                    completed: ProfileData.watch(context).completedCount,
                  ),
                ),
              ),
              ProfileTile(
                icon: Icons.view_list_rounded,
                title: AppStrings.profileProgramProgress,
                subtitle: AppStrings.profileProgramsSubtitle(
                  data.completedCount,
                  data.totalExercises,
                ),
                onTap: () => open(AppStrings.profileProgramProgress, (context) {
                  final d = ProfileData.watch(context);
                  return ProgramProgressList(
                    programs: d.programs,
                    completed: d.progress.completedIds,
                    onReset: (program) => confirmResetProgram(context, program),
                  );
                }),
              ),
              ProfileTile(
                icon: Icons.emoji_events_rounded,
                title: AppStrings.profileBadges,
                subtitle: AppStrings.profileBadgesSubtitle(
                  data.unlockedCount,
                  data.statuses.length,
                ),
                onTap: () => open(
                  AppStrings.profileBadges,
                  (context) =>
                      BadgeGrid(statuses: ProfileData.watch(context).statuses),
                ),
              ),
            ],
          ),
          const SectionHeader(title: AppStrings.settingsGroupPreferences),
          ProfileTileGroup(
            tiles: [
              ProfileTile(
                icon: Icons.flag_rounded,
                title: AppStrings.profileGoals,
                subtitle: AppStrings.profileGoalsSubtitle(
                  settings.dailyGoal,
                  settings.weeklyGoal,
                ),
                onTap: () => open(AppStrings.profileGoals, (context) {
                  final d = ProfileData.watch(context);
                  final cubit = context.read<SettingsCubit>();
                  return Column(
                    spacing: 12.h,
                    children: [
                      DailyGoalSetting(
                        goal: d.settings.dailyGoal,
                        doneToday: d.doneToday,
                        onGoalChanged: cubit.setDailyGoal,
                      ),
                      WeeklyGoalCard(
                        activeDays: d.activeDaysThisWeek,
                        goal: d.settings.weeklyGoal,
                        onGoalChanged: cubit.setWeeklyGoal,
                      ),
                    ],
                  );
                }),
              ),
              ProfileTile(
                icon: Icons.brightness_6_rounded,
                title: AppStrings.profileAppearance,
                subtitle: _themeLabel(settings.themeMode),
                onTap: () => open(
                  AppStrings.profileAppearance,
                  (context) => ThemeCard(
                    themeMode: context.watch<SettingsCubit>().state.themeMode,
                  ),
                ),
              ),
              ProfileTile(
                icon: Icons.timer_rounded,
                title: AppStrings.profileTimerFeedback,
                subtitle: AppStrings.profileTimerFeedbackSubtitle,
                onTap: () => open(
                  AppStrings.profileTimerFeedback,
                  (context) => TimerPreferencesCard(
                    settings: context.watch<SettingsCubit>().state,
                  ),
                ),
              ),
            ],
          ),
          const SectionHeader(title: AppStrings.settingsGroupData),
          ProfileTileGroup(
            tiles: [
              ProfileTile(
                icon: Icons.copy_all_outlined,
                title: AppStrings.settingsExport,
                showChevron: false,
                onTap: () =>
                    copySummary(context, data.summary(AppStrings.appName)),
              ),
              ProfileTile(
                icon: Icons.restart_alt,
                title: AppStrings.settingsResetProgress,
                destructive: true,
                showChevron: false,
                onTap: () => confirmResetAll(context),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ProfileTileGroup(
            tiles: [
              ProfileTile(
                icon: Icons.info_outline,
                title: AppStrings.settingsAbout,
                showChevron: false,
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: AppStrings.appName,
                  applicationVersion: '1.0.0',
                  applicationLegalese: AppStrings.settingsLegalese,
                ),
              ),
              ProfileTile(
                icon: Icons.logout,
                title: AppStrings.settingsLogOut,
                showChevron: false,
                onTap: () => context.read<AppSession>().logOut(),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
