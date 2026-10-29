import 'package:calistracker/app/app_dependencies.dart';
import 'package:calistracker/features/profile/presentation/bloc/settings_cubit.dart';
import 'package:calistracker/features/progress/domain/usecases/complete_exercise.dart';
import 'package:calistracker/features/progress/domain/usecases/get_progress.dart';
import 'package:calistracker/features/progress/domain/usecases/reset_exercises.dart';
import 'package:calistracker/features/progress/domain/usecases/reset_progress.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/domain/usecases/get_programs.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Provides the session and every app-wide bloc/cubit to the widget tree.
class AppProviders extends StatelessWidget {
  const AppProviders({
    super.key,
    required this.dependencies,
    required this.child,
  });

  final AppDependencies dependencies;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider.value(value: dependencies.session),
        BlocProvider(
          create: (_) => SettingsCubit(dependencies.settingsRepository),
        ),
        BlocProvider(
          create: (_) =>
              ProgramsBloc(GetPrograms(dependencies.programsRepository))
                ..add(const ProgramsRequested()),
        ),
        BlocProvider(
          create: (_) => ProgressBloc(
            GetProgress(dependencies.progressRepository),
            CompleteExercise(dependencies.progressRepository),
            ResetProgress(dependencies.progressRepository),
            ResetExercises(dependencies.progressRepository),
          )..add(const ProgressRequested()),
        ),
      ],
      child: child,
    );
  }
}
