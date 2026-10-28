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
      return 'This field is required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Enter valid email address';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.contains(RegExp(r'\s'))) {
      return 'Password must not contain spaces';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? confirmPasswordValidator(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? firstNameValidator(String? value) => _name(value, 'First');

  static String? lastNameValidator(String? value) => _name(value, 'Last');

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!_phoneRegex.hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? _name(String? value, String label) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return '$label name is required';
    }
    if (name.length < 2) {
      return '$label name must be at least 2 characters';
    }
    if (!_nameRegex.hasMatch(name)) {
      return 'Enter a valid ${label.toLowerCase()} name';
    }
    return null;
  }
}
