import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Stepper for the number of exercises to finish per day.
class DailyGoalSetting extends StatelessWidget {
  const DailyGoalSetting({
    super.key,
    required this.goal,
    required this.doneToday,
    required this.onGoalChanged,
  });

  final int goal;
  final int doneToday;
  final ValueChanged<int> onGoalChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: AppText(
                  text: AppStrings.profileDailyGoal,
                  fWeight: FontWeight.w600,
                ),
              ),
              IconButton.filledTonal(
                tooltip: AppStrings.profileDailyLower,
                onPressed: goal > SettingsCubit.minDailyGoal
                    ? () => onGoalChanged(goal - 1)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 96.w,
                child: AppText(
                  text: AppStrings.profileDailyGoalValue(goal),
                  textAlign: TextAlign.center,
                  fWeight: FontWeight.bold,
                ),
              ),
              IconButton.filledTonal(
                tooltip: AppStrings.profileDailyRaise,
                onPressed: goal < SettingsCubit.maxDailyGoal
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
              value: (doneToday / goal).clamp(0.0, 1.0),
              minHeight: 8.h,
              color: scheme.primary,
              backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
            ),
          ),
          SizedBox(height: 6.h),
          AppText(
            text: AppStrings.profileDailyGoalHint,
            fSize: 12.sp,
            textColor: scheme.onSurface.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}
