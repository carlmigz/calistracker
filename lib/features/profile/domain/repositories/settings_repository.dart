import 'package:flutter/material.dart' show ThemeMode;

abstract class SettingsRepository {
  String get displayName;
  ThemeMode get themeMode;

  /// Target number of active days per week.
  int get weeklyGoal;

  /// Target number of exercises per day.
  int get dailyGoal;

  /// Index into the avatar color palette.
  int get avatarColorIndex;

  /// Asset path of the chosen avatar pose; empty for the default mascot.
  String get avatarAsset;

  bool get hapticsEnabled;
  bool get soundEnabled;

  /// Rest timer length (seconds) the timer opens with.
  int get defaultRestSeconds;

  Future<void> setDisplayName(String name);
  Future<void> setThemeMode(ThemeMode mode);
  Future<void> setWeeklyGoal(int days);
  Future<void> setDailyGoal(int exercises);
  Future<void> setAvatarColorIndex(int index);
  Future<void> setAvatarAsset(String asset);
  Future<void> setHapticsEnabled(bool enabled);
  Future<void> setSoundEnabled(bool enabled);
  Future<void> setDefaultRestSeconds(int seconds);
}
