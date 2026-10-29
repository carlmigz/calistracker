import 'package:calistracker/features/profile/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._prefs);

  static const defaultName = 'Athlete';
  static const defaultWeeklyGoal = 3;
  static const defaultDailyGoal = 3;
  static const defaultRest = 60;
  static const _nameKey = 'display_name';
  static const _themeKey = 'theme_mode';
  static const _goalKey = 'weekly_goal';
  static const _dailyGoalKey = 'daily_goal';
  static const _avatarKey = 'avatar_color';
  static const _avatarAssetKey = 'avatar_asset';
  static const _hapticsKey = 'haptics_enabled';
  static const _soundKey = 'sound_enabled';
  static const _restKey = 'default_rest_seconds';

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
  int get weeklyGoal => _prefs.getInt(_goalKey) ?? defaultWeeklyGoal;

  @override
  int get dailyGoal => _prefs.getInt(_dailyGoalKey) ?? defaultDailyGoal;

  @override
  int get avatarColorIndex => _prefs.getInt(_avatarKey) ?? 0;

  @override
  String get avatarAsset => _prefs.getString(_avatarAssetKey) ?? '';

  @override
  bool get hapticsEnabled => _prefs.getBool(_hapticsKey) ?? true;

  @override
  bool get soundEnabled => _prefs.getBool(_soundKey) ?? false;

  @override
  int get defaultRestSeconds => _prefs.getInt(_restKey) ?? defaultRest;

  @override
  Future<void> setDisplayName(String name) => _prefs.setString(_nameKey, name);

  @override
  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(_themeKey, mode.name);

  @override
  Future<void> setWeeklyGoal(int days) => _prefs.setInt(_goalKey, days);

  @override
  Future<void> setDailyGoal(int exercises) =>
      _prefs.setInt(_dailyGoalKey, exercises);

  @override
  Future<void> setAvatarColorIndex(int index) =>
      _prefs.setInt(_avatarKey, index);

  @override
  Future<void> setAvatarAsset(String asset) =>
      _prefs.setString(_avatarAssetKey, asset);

  @override
  Future<void> setHapticsEnabled(bool enabled) =>
      _prefs.setBool(_hapticsKey, enabled);

  @override
  Future<void> setSoundEnabled(bool enabled) =>
      _prefs.setBool(_soundKey, enabled);

  @override
  Future<void> setDefaultRestSeconds(int seconds) =>
      _prefs.setInt(_restKey, seconds);
}
