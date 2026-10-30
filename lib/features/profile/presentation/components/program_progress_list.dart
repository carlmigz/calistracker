import 'package:calistracker/core/components/app_card.dart';
import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/features/progress/domain/entities/completion.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// An overview of all programs, then one expandable card per program with its
/// progress, difficulty split, muscles, activity and exercise checklist.
class ProgramProgressList extends StatelessWidget {
  const ProgramProgressList({
    super.key,
    required this.programs,
    required this.completed,
    required this.completions,
    required this.now,
    required this.onReset,
    required this.onOpenExercise,
  });

  final List<Program> programs;
  final Set<String> completed;
  final List<Completion> completions;
  final DateTime now;
  final ValueChanged<Program> onReset;
  final void Function(Program program, Exercise exercise) onOpenExercise;

  @override
  Widget build(BuildContext context) {
    final totalExercises = programs.fold(0, (s, p) => s + p.exercises.length);
    final done = programs.fold(0, (s, p) => s + p.completedCount(completed));
    final finished = programs
        .where(
          (p) =>
              p.exercises.isNotEmpty &&
              p.completedCount(completed) == p.exercises.length,
        )
        .length;
    final firstOpen = programs.indexWhere(
      (p) => p.completedCount(completed) < p.exercises.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Overview(
          finished: finished,
          programCount: programs.length,
          done: done,
          total: totalExercises,
          sessions: completions.length,
        ),
        SizedBox(height: 16.h),
        for (var i = 0; i < programs.length; i++) ...[
          _ProgramCard(
            program: programs[i],
            completed: completed,
            completions: completions
                .where(
                  (c) => programs[i].exercises.any((e) => e.id == c.exerciseId),
                )
                .toList(),
            now: now,
            initiallyExpanded: i == firstOpen,
            onReset: () => onReset(programs[i]),
            onOpenExercise: (e) => onOpenExercise(programs[i], e),
          ),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({
    required this.finished,
    required this.programCount,
    required this.done,
    required this.total,
    required this.sessions,
  });

  final int finished;
  final int programCount;
  final int done;
  final int total;
  final int sessions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.6);
    final percent = total == 0 ? 0 : (done / total * 100).round();

    return AppCard(
      large: true,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(text: 'Overall', fSize: 12.sp, textColor: muted),
          AppText(
            text: '$percent% complete',
            fSize: 24.sp,
            fWeight: FontWeight.bold,
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              minHeight: 10.h,
              backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              _Stat(label: 'Programs done', value: '$finished / $programCount'),
              _Stat(label: 'Exercises', value: '$done / $total'),
              _Stat(label: 'Sessions', value: '$sessions'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          AppText(text: value, fWeight: FontWeight.bold, fSize: 14.sp),
          SizedBox(height: 2.h),
          AppText(
            text: label,
            fSize: 10.sp,
            textAlign: TextAlign.center,
            textColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({
    required this.program,
    required this.completed,
    required this.completions,
    required this.now,
    required this.initiallyExpanded,
    required this.onReset,
    required this.onOpenExercise,
  });

  final Program program;
  final Set<String> completed;

  /// Completions that belong to this program only.
  final List<Completion> completions;
  final DateTime now;
  final bool initiallyExpanded;
  final VoidCallback onReset;
  final ValueChanged<Exercise> onOpenExercise;

  String _lastTrained() {
    final dated = completions.where((c) => c.hasKnownDate);
    if (dated.isEmpty) return completions.isEmpty ? 'Not started' : 'Unknown';
    final last = dated
        .map((c) => c.completedAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final days = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(last.year, last.month, last.day)).inDays;
    if (days <= 0) return AppStrings.today;
    if (days == 1) return AppStrings.yesterday;
    return '$days days ago';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.6);
    final exercises = program.exercises;
    final done = program.completedCount(completed);
    final total = exercises.length;
    final next = program.nextExercise(completed);
    final isFinished = total > 0 && done == total;

    final muscles = {for (final e in exercises) ...e.muscles}.toList();
    final levels = [
      for (final d in Difficulty.values)
        (
          d,
          [
            for (var i = 0; i < total; i++)
              if (program.difficultyOf(i) == d) exercises[i],
          ],
        ),
    ].where((l) => l.$2.isNotEmpty);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Row(
            children: [
              Expanded(
                child: AppText(
                  text: program.name,
                  fSize: 15.sp,
                  fWeight: FontWeight.bold,
                ),
              ),
              if (isFinished)
                Icon(Icons.verified, color: scheme.primary, size: 20.r),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : done / total,
                    minHeight: 6.h,
                    backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
                  ),
                ),
                SizedBox(height: 4.h),
                AppText(
                  text: '$done of $total exercises',
                  fSize: 11.sp,
                  textColor: muted,
                ),
              ],
            ),
          ),
          children: [
            AppText(text: program.description, fSize: 13.sp),
            SizedBox(height: 14.h),
            _InfoRow(
              icon: Icons.repeat,
              label: 'Sessions',
              value: '${completions.length}',
            ),
            _InfoRow(
              icon: Icons.history,
              label: 'Last trained',
              value: _lastTrained(),
            ),
            _InfoRow(
              icon: Icons.fitness_center,
              label: 'Muscles',
              value: muscles.join(', '),
            ),
            SizedBox(height: 12.h),
            AppText(text: 'Difficulty', fSize: 13.sp, fWeight: FontWeight.bold),
            SizedBox(height: 6.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: [
                for (final (level, list) in levels)
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      '${level.label} '
                      '${list.where((e) => completed.contains(e.id)).length}'
                      '/${list.length}',
                    ),
                  ),
              ],
            ),
            SizedBox(height: 14.h),
            AppText(text: 'Exercises', fSize: 13.sp, fWeight: FontWeight.bold),
            SizedBox(height: 4.h),
            for (var i = 0; i < total; i++)
              _ExerciseRow(
                number: i + 1,
                exercise: exercises[i],
                isDone: completed.contains(exercises[i].id),
                isUnlocked: program.isUnlocked(i, completed),
                isNext: next?.id == exercises[i].id,
                onTap: () => onOpenExercise(exercises[i]),
              ),
            SizedBox(height: 8.h),
            Row(
              children: [
                if (next != null)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => onOpenExercise(next),
                      icon: const Icon(Icons.play_arrow),
                      label: Text('Continue: ${next.name}'),
                    ),
                  )
                else
                  Expanded(
                    child: AppText(
                      text: 'Program complete. Great work!',
                      fSize: 13.sp,
                      fWeight: FontWeight.w600,
                    ),
                  ),
                SizedBox(width: 8.w),
                IconButton(
                  tooltip: AppStrings.profileResetProgram,
                  onPressed: done == 0 ? null : onReset,
                  icon: const Icon(Icons.restart_alt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.r, color: scheme.primary),
          SizedBox(width: 8.w),
          AppText(text: label, fSize: 12.sp, fWeight: FontWeight.w600),
          SizedBox(width: 8.w),
          Expanded(
            child: AppText(
              text: value,
              fSize: 12.sp,
              textAlign: TextAlign.end,
              textColor: scheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.number,
    required this.exercise,
    required this.isDone,
    required this.isUnlocked,
    required this.isNext,
    required this.onTap,
  });

  final int number;
  final Exercise exercise;
  final bool isDone;
  final bool isUnlocked;
  final bool isNext;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.5);

    return InkWell(
      onTap: isUnlocked ? onTap : null,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(
              isDone
                  ? Icons.check_circle
                  : isUnlocked
                  ? Icons.radio_button_unchecked
                  : Icons.lock_outline,
              size: 20.r,
              color: isDone || isNext ? scheme.primary : muted,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: AppText(
                text: '$number. ${exercise.name}',
                fSize: 13.sp,
                fWeight: isNext ? FontWeight.bold : FontWeight.w500,
                textColor: isUnlocked ? null : muted,
              ),
            ),
            AppText(text: exercise.target, fSize: 11.sp, textColor: muted),
          ],
        ),
      ),
    );
  }
}
