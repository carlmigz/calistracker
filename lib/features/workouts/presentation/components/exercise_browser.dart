import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/domain/entities/exercise.dart';
import 'package:calistracker/features/programs/domain/entities/program.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

typedef _Entry = ({
  Program program,
  int index,
  Exercise exercise,
  Difficulty difficulty,
});

/// Searchable list of every exercise with muscle and difficulty filters.
class ExerciseBrowser extends StatefulWidget {
  const ExerciseBrowser({super.key});

  @override
  State<ExerciseBrowser> createState() => _ExerciseBrowserState();
}

class _ExerciseBrowserState extends State<ExerciseBrowser> {
  String _query = '';
  String? _muscle;
  Difficulty? _difficulty;

  List<_Entry> _entries(List<Program> programs) => [
    for (final program in programs)
      for (final (i, exercise) in program.exercises.indexed)
        (
          program: program,
          index: i,
          exercise: exercise,
          difficulty: program.difficultyOf(i),
        ),
  ];

  void _open(BuildContext context, _Entry entry, Set<String> completed) {
    if (!entry.program.isUnlocked(entry.index, completed)) {
      final previous = entry.program.exercises[entry.index - 1].name;
      toastification.show(
        context: context,
        type: ToastificationType.info,
        title: Text('Finish "$previous" first'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }
    context.push(AppRoutes.exercise(entry.program.id, entry.exercise.id));
  }

  @override
  Widget build(BuildContext context) {
    final programs = context.select((ProgramsBloc bloc) => bloc.state.programs);
    final completed = context.select(
      (ProgressBloc bloc) => bloc.state.completed,
    );
    final scheme = Theme.of(context).colorScheme;

    final all = _entries(programs);
    final muscles = {for (final e in all) ...e.exercise.muscles}.toList()
      ..sort();

    final query = _query.trim().toLowerCase();
    final visible = all.where((e) {
      if (_muscle != null && !e.exercise.muscles.contains(_muscle)) {
        return false;
      }
      if (_difficulty != null && e.difficulty != _difficulty) return false;
      if (query.isEmpty) return true;
      return e.exercise.name.toLowerCase().contains(query) ||
          e.program.name.toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 4.h),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search exercises',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        _ChipRow<Difficulty>(
          values: Difficulty.values,
          selected: _difficulty,
          label: (d) => d.label,
          onChanged: (d) => setState(() => _difficulty = d),
        ),
        _ChipRow<String>(
          values: muscles,
          selected: _muscle,
          label: (m) => m,
          onChanged: (m) => setState(() => _muscle = m),
        ),
        Expanded(
          child: visible.isEmpty
              ? const Center(child: AppText(text: 'No exercises match'))
              : ListView.separated(
                  padding: AppSizes.bodyPadding,
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, i) {
                    final entry = visible[i];
                    final isDone = completed.contains(entry.exercise.id);
                    final isUnlocked = entry.program.isUnlocked(
                      entry.index,
                      completed,
                    );

                    return Opacity(
                      opacity: isUnlocked ? 1 : 0.55,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        tileColor: scheme.surfaceContainerHighest,
                        onTap: () => _open(context, entry, completed),
                        leading: CircleAvatar(
                          backgroundColor: isDone
                              ? scheme.primary
                              : scheme.surface,
                          foregroundColor: isDone
                              ? scheme.onPrimary
                              : scheme.onSurface,
                          child: Icon(
                            isDone
                                ? Icons.check
                                : isUnlocked
                                ? Icons.play_arrow_rounded
                                : Icons.lock,
                          ),
                        ),
                        title: AppText(
                          text: entry.exercise.name,
                          fWeight: FontWeight.w600,
                        ),
                        subtitle: AppText(
                          text:
                              '${entry.program.name.replaceAll(' Progression', '')}'
                              ' · ${entry.difficulty.label}'
                              ' · ${entry.exercise.target}',
                          fSize: 12.sp,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ChipRow<T> extends StatelessWidget {
  const _ChipRow({
    required this.values,
    required this.selected,
    required this.label,
    required this.onChanged,
  });

  final List<T> values;
  final T? selected;
  final String Function(T) label;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        itemCount: values.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final value = values[i];
          final isSelected = value == selected;
          return ChoiceChip(
            showCheckmark: false,
            selected: isSelected,
            selectedColor: scheme.primary,
            label: Text(
              label(value),
              style: TextStyle(
                color: isSelected ? scheme.onPrimary : scheme.onSurface,
              ),
            ),
            onSelected: (_) => onChanged(isSelected ? null : value),
          );
        },
      ),
    );
  }
}
