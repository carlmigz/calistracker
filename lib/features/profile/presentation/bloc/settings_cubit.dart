import 'package:calistracker/features/profile/data/repositories/settings_repository_impl.dart';
import 'package:calistracker/features/profile/domain/repositories/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Color, ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.displayName,
    required this.themeMode,
    required this.weeklyGoal,
    required this.dailyGoal,
    required this.avatarColorIndex,
    required this.avatarAsset,
    required this.hapticsEnabled,
    required this.soundEnabled,
    required this.defaultRestSeconds,
  });

  /// Avatar choices from `assets/icons`; the empty path is the default mascot.
  static const avatarAssets = [
    '',
    'assets/icons/avatar_01_fighting_stance.png',
    'assets/icons/avatar_02_punching.png',
    'assets/icons/avatar_03_kicking.png',
    'assets/icons/avatar_04_power_up.png',
    'assets/icons/avatar_05_crouching.png',
    'assets/icons/avatar_06_cross_armed.png',
    'assets/icons/avatar_07_looking_back.png',
    'assets/icons/avatar_08_running.png',
    'assets/icons/avatar_09_defending.png',
    'assets/icons/avatar_10_victory.png',
  ];

  /// Avatar background choices; the first is the brand yellow.
  static const avatarColors = [
    Color(0xFFFEC200),
    Color(0xFFFF8A65),
    Color(0xFF4FC3F7),
    Color(0xFF81C784),
    Color(0xFFBA68C8),
    Color(0xFFF06292),
  ];

  final String displayName;
  final ThemeMode themeMode;
  final int weeklyGoal;
  final int dailyGoal;
  final int avatarColorIndex;
  final String avatarAsset;
  final bool hapticsEnabled;
  final bool soundEnabled;
  final int defaultRestSeconds;

  /// The avatar to show, or null for the default mascot. Choices saved by an
  /// older version (no longer offered) also fall back to the mascot.
  String? get avatarPose =>
      avatarAsset.isEmpty || !avatarAssets.contains(avatarAsset)
      ? null
      : avatarAsset;

  Color get avatarColor =>
      avatarColors[avatarColorIndex.clamp(0, avatarColors.length - 1)];

  SettingsState copyWith({
    String? displayName,
    ThemeMode? themeMode,
    int? weeklyGoal,
    int? dailyGoal,
    int? avatarColorIndex,
    String? avatarAsset,
    bool? hapticsEnabled,
    bool? soundEnabled,
    int? defaultRestSeconds,
  }) {
    return SettingsState(
      displayName: displayName ?? this.displayName,
      themeMode: themeMode ?? this.themeMode,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      avatarColorIndex: avatarColorIndex ?? this.avatarColorIndex,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
    );
  }

  @override
  List<Object?> get props => [
    displayName,
    themeMode,
    weeklyGoal,
    dailyGoal,
    avatarColorIndex,
    avatarAsset,
    hapticsEnabled,
    soundEnabled,
    defaultRestSeconds,
  ];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository)
    : super(
        SettingsState(
          displayName: _repository.displayName,
          themeMode: _repository.themeMode,
          weeklyGoal: _repository.weeklyGoal,
          dailyGoal: _repository.dailyGoal,
          avatarColorIndex: _repository.avatarColorIndex,
          avatarAsset: _repository.avatarAsset,
          hapticsEnabled: _repository.hapticsEnabled,
          soundEnabled: _repository.soundEnabled,
          defaultRestSeconds: _repository.defaultRestSeconds,
        ),
      );

  static const minWeeklyGoal = 1;
  static const maxWeeklyGoal = 7;
  static const minDailyGoal = 1;
  static const maxDailyGoal = 10;

  /// Rest lengths offered in the timer and the default-rest setting.
  static const restPresets = [30, 60, 90, 120, 180];

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

  Future<void> setDailyGoal(int exercises) async {
    final value = exercises.clamp(minDailyGoal, maxDailyGoal);
    await _repository.setDailyGoal(value);
    emit(state.copyWith(dailyGoal: value));
  }

  Future<void> setAvatarColorIndex(int index) async {
    await _repository.setAvatarColorIndex(index);
    emit(state.copyWith(avatarColorIndex: index));
  }

  Future<void> setAvatarAsset(String asset) async {
    await _repository.setAvatarAsset(asset);
    emit(state.copyWith(avatarAsset: asset));
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    await _repository.setHapticsEnabled(enabled);
    emit(state.copyWith(hapticsEnabled: enabled));
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _repository.setSoundEnabled(enabled);
    emit(state.copyWith(soundEnabled: enabled));
  }

  Future<void> setDefaultRestSeconds(int seconds) async {
    await _repository.setDefaultRestSeconds(seconds);
    emit(state.copyWith(defaultRestSeconds: seconds));
  }
}
