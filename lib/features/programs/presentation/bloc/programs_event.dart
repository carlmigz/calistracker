part of 'programs_bloc.dart';

sealed class ProgramsEvent extends Equatable {
  const ProgramsEvent();

  @override
  List<Object?> get props => [];
}

class ProgramsRequested extends ProgramsEvent {
  const ProgramsRequested();
}
