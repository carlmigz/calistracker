import 'package:calistracker/features/profile/data/repositories/settings_repository_impl.dart';
import 'package:calistracker/features/profile/domain/repositories/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.displayName,
    required this.themeMode,
    required this.weeklyGoal,
  });

  final String displayName;
  final ThemeMode themeMode;
  final int weeklyGoal;

  SettingsState copyWith({
    String? displayName,
    ThemeMode? themeMode,
    int? weeklyGoal,
  }) {
    return SettingsState(
      displayName: displayName ?? this.displayName,
      themeMode: themeMode ?? this.themeMode,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
    );
  }

  @override
  List<Object?> get props => [displayName, themeMode, weeklyGoal];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository)
    : super(
        SettingsState(
          displayName: _repository.displayName,
          themeMode: _repository.themeMode,
          weeklyGoal: _repository.weeklyGoal,
        ),
      );

  static const minWeeklyGoal = 1;
  static const maxWeeklyGoal = 7;

  final SettingsRepository _repository;

  Future<void> setDisplayName(String name) async {
    final trimmed = name.trim();
    final value = trimmed.isEmpty
        ? SettingsRepositoryImpl.defaultName
        : trimmed;
    await _repository.setDisplayName(value);
    emit(state.copyWith(displayName: value));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repository.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setWeeklyGoal(int days) async {
    final value = days.clamp(minWeeklyGoal, maxWeeklyGoal);
    await _repository.setWeeklyGoal(value);
    emit(state.copyWith(weeklyGoal: value));
  }
}
