import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/components/pose_image.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/progress/presentation/components/recent_activity_tile.dart';
import 'package:calistracker/features/progress/presentation/components/stat_card.dart';
import 'package:calistracker/features/progress/presentation/components/week_chart.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressBloc>().state.progress;
    final programs = context.watch<ProgramsBloc>().state;
    final now = DateTime.now();
    final recent = progress.recent(10);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.progress)),
      body: ListView(
        padding: AppSizes.bodyPadding,
        children: [
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.local_fire_department,
                  value: '${progress.currentStreak(now)}',
                  label: AppStrings.dayStreak,
                  highlighted: true,
                ),
              ),
              Expanded(
                  child: StatCard(
                  icon: Icons.check_circle_outline,
                  value: '${progress.completions.length}',
                  label: AppStrings.progressSessionsDone,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          AppText(
            text: AppStrings.progressThisWeek,
            fWeight: FontWeight.bold,
            fSize: 18.sp,
          ),
          SizedBox(height: 12.h),
          WeekChart(week: progress.activityLast7Days(now), now: now),
          SizedBox(height: 20.h),
          AppText(
            text: AppStrings.progressRecentActivity,
            fWeight: FontWeight.bold,
            fSize: 18.sp,
          ),
          SizedBox(height: 12.h),
          if (recent.isEmpty)
            Column(
              children: [
                PoseImage(height: 120.h),
                SizedBox(height: 8.h),
                const AppText(
                  text: AppStrings.progressEmptyActivity,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          else
            for (final completion in recent)
              RecentActivityTile(
                title:
                    programs.findExercise(completion.exerciseId)?.name ??
                    completion.exerciseId,
                date: completion.completedAt,
                now: now,
              ),
        ],
      ),
    );
  }
}
