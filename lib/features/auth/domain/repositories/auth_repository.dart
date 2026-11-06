import 'package:calistracker/features/auth/domain/entities/account_profile.dart';

abstract interface class AuthRepository {
  /// The profile saved at sign up, or null if the user never created one.
  AccountProfile? get profile;

  Future<void> saveProfile(AccountProfile profile);
}
