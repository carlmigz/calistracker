import 'package:calistracker/core/components/app_text.dart';
import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/router/app_router.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProgramDetailPage extends StatelessWidget {
  const ProgramDetailPage({super.key, required this.programId});

  final String programId;

  @override
  Widget build(BuildContext context) {
    final program = context.select(
      (ProgramsBloc bloc) => bloc.state.programById(programId),
    );
    final completed = context.select(
      (ProgressBloc bloc) => bloc.state.completed,
    );

    if (program == null) {
      return const Scaffold(body: Center(child: Text('Program not found')));
    }

    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(program.name)),
      body: ListView.separated(
        padding: AppSizes.bodyPadding,
        itemCount: program.exercises.length,
        separatorBuilder: (_, _) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final exercise = program.exercises[index];
          final isDone = completed.contains(exercise.id);
          final isUnlocked = program.isUnlocked(index, completed);

          return Opacity(
            opacity: isUnlocked ? 1 : 0.5,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              tileColor: scheme.surfaceContainerHighest,
              enabled: isUnlocked,
              onTap: isUnlocked
                  ? () => context.push(
                      AppRoutes.exercise(program.id, exercise.id),
                    )
                  : null,
              leading: CircleAvatar(
                backgroundColor: isDone ? scheme.primary : scheme.surface,
                foregroundColor: isDone ? scheme.onPrimary : scheme.onSurface,
                child: isDone ? const Icon(Icons.check) : Text('${index + 1}'),
              ),
              title: AppText(
                text: exercise.name,
                fFamily: AppTextStyles.fontFamily,
                fWeight: FontWeight.w600,
              ),
              subtitle: AppText(text: exercise.target, fSize: 12.sp),
              trailing: Icon(isUnlocked ? Icons.chevron_right : Icons.lock),
            ),
          );
        },
      ),
    );
  }
}
