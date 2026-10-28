import 'package:calistracker/features/profile/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._prefs);

  static const defaultName = 'Athlete';
  static const _nameKey = 'display_name';
  static const _themeKey = 'theme_mode';

  final SharedPreferences _prefs;

  @override
  String get displayName => _prefs.getString(_nameKey) ?? defaultName;

  @override
  ThemeMode get themeMode {
    final stored = _prefs.getString(_themeKey);
    return ThemeMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<void> setDisplayName(String name) => _prefs.setString(_nameKey, name);

  @override
  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(_themeKey, mode.name);
}
