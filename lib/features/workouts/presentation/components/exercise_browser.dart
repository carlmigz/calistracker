import 'package:calistracker/core/components/app_toast.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/constants/app_strings.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:calistracker/features/workouts/presentation/components/browser_empty_state.dart';
import 'package:calistracker/features/workouts/presentation/components/browser_summary.dart';
import 'package:calistracker/features/workouts/presentation/components/exercise_entry.dart';
import 'package:calistracker/features/workouts/presentation/components/exercise_tile.dart';
import 'package:calistracker/features/workouts/presentation/components/filter_chip_row.dart';
import 'package:calistracker/features/workouts/presentation/components/program_group_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Searchable list of every exercise, grouped by program, with muscle and
/// difficulty filters.
class ExerciseBrowser extends HookWidget {
  const ExerciseBrowser({super.key});

  static List<ExerciseEntry> _entries(Program program) => [
    for (final (i, exercise) in program.exercises.indexed)
      (
        program: program,
        index: i,
        exercise: exercise,
        difficulty: program.difficultyOf(i),
      ),
  ];

  static bool _matches(
    ExerciseEntry e,
    String query,
    String? muscle,
    Difficulty? difficulty,
  ) {
    if (muscle != null && !e.exercise.muscles.contains(muscle)) return false;
    if (difficulty != null && e.difficulty != difficulty) return false;
    if (query.isEmpty) return true;
    return e.exercise.name.toLowerCase().contains(query) ||
        e.program.name.toLowerCase().contains(query);
  }

  void _open(BuildContext context, ExerciseEntry entry, Set<String> completed) {
    if (!entry.program.isUnlocked(entry.index, completed)) {
      final previous = entry.program.exercises[entry.index - 1].name;
      showAppToast(context, AppStrings.workoutsFinishFirst(previous));
      return;
    }
    context.push(AppRoutes.exercise(entry.program.id, entry.exercise.id));
  }

  @override
  Widget build(BuildContext context) {
    final search = useTextEditingController();
    useListenable(search);
    final muscle = useState<String?>(null);
    final difficulty = useState<Difficulty?>(null);
    final hasFilter =
        search.text.isNotEmpty ||
        muscle.value != null ||
        difficulty.value != null;

    final programs = context.select((ProgramsBloc bloc) => bloc.state.programs);
    final completed = context.select(
      (ProgressBloc bloc) => bloc.state.completed,
    );

    final muscles = {
      for (final p in programs)
        for (final e in p.exercises) ...e.muscles,
    }.toList()..sort();

    void clearFilters() {
      search.clear();
      muscle.value = null;
      difficulty.value = null;
    }

    final query = search.text.trim().toLowerCase();
    final groups = [
      for (final program in programs)
        (
          program: program,
          entries: _entries(program)
              .where((e) => _matches(e, query, muscle.value, difficulty.value))
              .toList(),
        ),
    ].where((g) => g.entries.isNotEmpty).toList();

    final total = programs.fold(0, (sum, p) => sum + p.exercises.length);
    final done = programs.fold(
      0,
      (sum, p) => sum + p.completedCount(completed),
    );

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 4.h),
          child: TextField(
            controller: search,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: AppStrings.workoutsSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: search.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: AppStrings.workoutsClearSearch,
                      icon: const Icon(Icons.close),
                      onPressed: search.clear,
                    ),
            ),
          ),
        ),
        FilterChipRow<Difficulty>(
          values: Difficulty.values,
          selected: difficulty.value,
          label: (d) => d.label,
          onChanged: (d) => difficulty.value = d,
        ),
        FilterChipRow<String>(
          values: muscles,
          selected: muscle.value,
          label: (m) => m,
          onChanged: (m) => muscle.value = m,
        ),
        Expanded(
          child: groups.isEmpty
              ? BrowserEmptyState(onClear: hasFilter ? clearFilters : null)
              : ListView(
                  padding: AppSizes.bodyPadding,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    if (total > 0 && !hasFilter)
                      BrowserSummary(done: done, total: total),
                    for (final group in groups) ...[
                      ProgramGroupHeader(
                        program: group.program,
                        done: group.program.completedCount(completed),
                      ),
                      for (final entry in group.entries)
                        ExerciseTile(
                          entry: entry,
                          completed: completed,
                          onTap: () => _open(context, entry, completed),
                        ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}
