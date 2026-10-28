import 'package:calistracker/features/profile/data/repositories/settings_repository_impl.dart';
import 'package:calistracker/features/profile/domain/repositories/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({required this.displayName, required this.themeMode});

  final String displayName;
  final ThemeMode themeMode;

  @override
  List<Object?> get props => [displayName, themeMode];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository)
    : super(
        SettingsState(
          displayName: _repository.displayName,
          themeMode: _repository.themeMode,
        ),
      );

  final SettingsRepository _repository;

  Future<void> setDisplayName(String name) async {
    final trimmed = name.trim();
    final value = trimmed.isEmpty
        ? SettingsRepositoryImpl.defaultName
        : trimmed;
    await _repository.setDisplayName(value);
    emit(SettingsState(displayName: value, themeMode: state.themeMode));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repository.setThemeMode(mode);
    emit(SettingsState(displayName: state.displayName, themeMode: mode));
  }
}
