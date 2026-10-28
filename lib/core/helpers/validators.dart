import 'package:calistracker/core/constants/app_strings.dart';

class Validators {
  Validators._();

  static final _emailRegex = RegExp(
    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    caseSensitive: false,
  );
  static final _nameRegex = RegExp(r"^[a-zA-Z\s\.\-']+$");
  static final _phoneRegex = RegExp(r'^[0-9]{10}$');

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.contains(RegExp(r'\s'))) {
      return AppStrings.passwordNoSpaces;
    }
    if (value.length < 8) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  static String? confirmPasswordValidator(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPasswordRequired;
    }
    if (value != originalPassword) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  static String? firstNameValidator(String? value) =>
      _name(value, AppStrings.firstNameLabel);

  static String? lastNameValidator(String? value) =>
      _name(value, AppStrings.lastNameLabel);

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.phoneRequired;
    }
    if (!_phoneRegex.hasMatch(value)) {
      return AppStrings.phoneInvalid;
    }
    return null;
  }

  static String? _name(String? value, String label) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return AppStrings.nameRequired(label);
    }
    if (name.length < 2) {
      return AppStrings.nameTooShort(label);
    }
    if (!_nameRegex.hasMatch(name)) {
      return AppStrings.nameInvalid(label);
    }
    return null;
  }
}
