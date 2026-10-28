import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local onboarding/login flags. Drives the router redirects.
class AppSession {
  AppSession(this._prefs);

  final SharedPreferences _prefs;
  final _changes = ValueNotifier<int>(0);

  /// Fires whenever a flag changes; used as the router refresh trigger.
  Listenable get changes => _changes;

  static const _onboardingSeenKey = 'onboarding_seen';
  static const _loggedInKey = 'logged_in';

  bool get onboardingSeen => _prefs.getBool(_onboardingSeenKey) ?? false;
  bool get isLoggedIn => _prefs.getBool(_loggedInKey) ?? false;

  Future<void> completeOnboarding() => _set(_onboardingSeenKey, true);
  Future<void> logIn() => _set(_loggedInKey, true);
  Future<void> logOut() => _set(_loggedInKey, false);

  void dispose() => _changes.dispose();

  Future<void> _set(String key, bool value) async {
    await _prefs.setBool(key, value);
    _changes.value++;
  }
}
