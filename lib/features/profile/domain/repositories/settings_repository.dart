import 'package:flutter/material.dart' show ThemeMode;

abstract class SettingsRepository {
  String get displayName;
  ThemeMode get themeMode;

  Future<void> setDisplayName(String name);
  Future<void> setThemeMode(ThemeMode mode);
}
