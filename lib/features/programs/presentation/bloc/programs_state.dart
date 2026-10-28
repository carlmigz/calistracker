part of 'programs_bloc.dart';

enum ProgramsStatus { initial, loading, success, failure }

class ProgramsState extends Equatable {
  const ProgramsState({
    this.status = ProgramsStatus.initial,
    this.programs = const [],
    this.error,
  });

  final ProgramsStatus status;
  final List<Program> programs;
  final String? error;

  int get totalExercises =>
      programs.fold(0, (sum, p) => sum + p.exercises.length);

  Program? programById(String id) {
    for (final program in programs) {
      if (program.id == id) return program;
    }
    return null;
  }

  Exercise? findExercise(String exerciseId) {
    for (final program in programs) {
      for (final exercise in program.exercises) {
        if (exercise.id == exerciseId) return exercise;
      }
    }
    return null;
  }

  Exercise? exerciseById(String programId, String exerciseId) {
    final program = programById(programId);
    if (program == null) return null;
    for (final exercise in program.exercises) {
      if (exercise.id == exerciseId) return exercise;
    }
    return null;
  }

  @override
  List<Object?> get props => [status, programs, error];
}
