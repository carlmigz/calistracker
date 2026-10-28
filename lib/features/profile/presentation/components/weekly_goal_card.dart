import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows how many days were active this week against the goal, and lets the
/// user raise or lower the goal.
class WeeklyGoalCard extends StatelessWidget {
  const WeeklyGoalCard({
    super.key,
    required this.activeDays,
    required this.goal,
    required this.onGoalChanged,
  });

  final int activeDays;
  final int goal;
  final ValueChanged<int> onGoalChanged;

  @override
  Widget build(BuildContext context) {
    final reached = activeDays >= goal;

    return AppCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: AppText(
                  text: AppStrings.profileWeeklyGoal,
                  fWeight: FontWeight.w600,
                ),
              ),
              IconButton.filledTonal(
                tooltip: AppStrings.profileGoalLower,
                onPressed: goal > SettingsCubit.minWeeklyGoal
                    ? () => onGoalChanged(goal - 1)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 64.w,
                child: AppText(
                  text: AppStrings.profileGoalDays(goal),
                  textAlign: TextAlign.center,
                  fWeight: FontWeight.bold,
                ),
              ),
              IconButton.filledTonal(
                tooltip: AppStrings.profileGoalRaise,
                onPressed: goal < SettingsCubit.maxWeeklyGoal
                    ? () => onGoalChanged(goal + 1)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: (activeDays / goal).clamp(0, 1),
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: 6.h),
          AppText(
            text: reached
                ? AppStrings.profileGoalReached
                : AppStrings.profileGoalProgress(activeDays, goal),
            fSize: 12.sp,
            fWeight: reached ? FontWeight.w600 : null,
          ),
        ],
      ),
    );
  }
}
