import 'package:flutter/material.dart' show ThemeMode;

abstract class SettingsRepository {
  String get displayName;
  ThemeMode get themeMode;

  /// Target number of active days per week.
  int get weeklyGoal;

  Future<void> setDisplayName(String name);
  Future<void> setThemeMode(ThemeMode mode);
  Future<void> setWeeklyGoal(int days);
}
