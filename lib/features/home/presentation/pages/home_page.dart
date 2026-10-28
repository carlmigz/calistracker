import 'package:calistracker/features/home/presentation/components/error_view.dart';
import 'package:calistracker/features/home/presentation/components/home_content.dart';
import 'package:calistracker/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:calistracker/features/programs/presentation/bloc/programs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProgramsBloc, ProgramsState>(
          builder: (context, programsState) {
            switch (programsState.status) {
              case ProgramsStatus.initial:
              case ProgramsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case ProgramsStatus.failure:
                return ErrorView(message: programsState.error);
              case ProgramsStatus.success:
                return BlocBuilder<ProgressBloc, ProgressState>(
                  builder: (context, progress) => HomeContent(
                    programs: programsState.programs,
                    total: programsState.totalExercises,
                    completed: progress.completed,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
