import 'package:calistracker/features/auth/domain/entities/account_profile.dart';
import 'package:calistracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local-only storage; there is no backend and the password is never kept.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._prefs);

  static const _emailKey = 'account_email';
  static const _genderKey = 'account_gender';
  static const _ageKey = 'account_age';
  static const _heightKey = 'account_height_cm';
  static const _weightKey = 'account_weight_kg';
  static const _heightUnitKey = 'account_height_unit';
  static const _weightUnitKey = 'account_weight_unit';
  static const _goalsKey = 'account_goals';
  static const _experienceKey = 'account_experience';
  static const _daysKey = 'account_days_per_week';

  final SharedPreferences _prefs;

  @override
  AccountProfile? get profile {
    final email = _prefs.getString(_emailKey);
    final height = _prefs.getDouble(_heightKey);
    final weight = _prefs.getDouble(_weightKey);
    if (email == null || height == null || weight == null) return null;

    T pick<T extends Enum>(List<T> values, String key, T fallback) {
      final stored = _prefs.getString(key);
      return values.firstWhere((v) => v.name == stored, orElse: () => fallback);
    }

    return AccountProfile(
      email: email,
      gender: pick(Gender.values, _genderKey, Gender.preferNotToSay),
      age: _prefs.getInt(_ageKey) ?? 25,
      heightCm: height,
      weightKg: weight,
      heightUnit: pick(HeightUnit.values, _heightUnitKey, HeightUnit.cm),
      weightUnit: pick(WeightUnit.values, _weightUnitKey, WeightUnit.kg),
      goals: {
        for (final name in _prefs.getStringList(_goalsKey) ?? const <String>[])
          ...FitnessGoal.values.where((g) => g.name == name),
      },
      experience: pick(
        ExperienceLevel.values,
        _experienceKey,
        ExperienceLevel.newbie,
      ),
      daysPerWeek: _prefs.getInt(_daysKey) ?? 3,
    );
  }

  @override
  Future<void> saveProfile(AccountProfile profile) async {
    await _prefs.setString(_emailKey, profile.email);
    await _prefs.setString(_genderKey, profile.gender.name);
    await _prefs.setInt(_ageKey, profile.age);
    await _prefs.setDouble(_heightKey, profile.heightCm);
    await _prefs.setDouble(_weightKey, profile.weightKg);
    await _prefs.setString(_heightUnitKey, profile.heightUnit.name);
    await _prefs.setString(_weightUnitKey, profile.weightUnit.name);
    await _prefs.setStringList(
      _goalsKey,
      profile.goals.map((g) => g.name).toList(),
    );
    await _prefs.setString(_experienceKey, profile.experience.name);
    await _prefs.setInt(_daysKey, profile.daysPerWeek);
  }
}
