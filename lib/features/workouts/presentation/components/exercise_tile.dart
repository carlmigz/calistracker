import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/workouts/presentation/components/exercise_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({
    super.key,
    required this.entry,
    required this.completed,
    required this.onTap,
  });

  final ExerciseEntry entry;
  final Set<String> completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDone = completed.contains(entry.exercise.id);
    final isUnlocked = entry.program.isUnlocked(entry.index, completed);
    final isNext =
        entry.program.nextExercise(completed)?.id == entry.exercise.id;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Opacity(
        opacity: isUnlocked ? 1 : 0.55,
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: isDone ? scheme.primary : scheme.surface,
            foregroundColor: isDone ? scheme.onPrimary : scheme.onSurface,
            child: Icon(
              isDone
                  ? Icons.check
                  : isUnlocked
                  ? Icons.play_arrow_rounded
                  : Icons.lock,
            ),
          ),
          title: AppText(text: entry.exercise.name, fWeight: FontWeight.w600),
          subtitle: AppText(
            text: '${entry.difficulty.label} · ${entry.exercise.target}',
            fSize: 12.sp,
          ),
          trailing: isNext
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AppText(
                    text: AppStrings.workoutsUpNext,
                    fSize: 11.sp,
                    fWeight: FontWeight.w600,
                    textColor: scheme.onPrimary,
                  ),
                )
              : isUnlocked
              ? const Icon(Icons.chevron_right)
              : null,
        ),
      ),
    );
  }
}
