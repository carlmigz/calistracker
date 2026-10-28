class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    final emailRegex = RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
      caseSensitive: false,
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter valid email address';
    }
    return null;
  }

  String? validateAmount(String? value, String balance) {
    const double minimumAmount = 100.0;

    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    }

    final amountNum = double.tryParse(value.trim());
    final balanceNum = double.tryParse(balance) ?? 0;

    if (amountNum == null || amountNum <= 0) {
      return 'Please enter a valid amount greater than ₱0';
    }
    if (amountNum < minimumAmount) {
      return 'Minimum withdrawal is ₱${minimumAmount.toStringAsFixed(2)}';
    }
    if (amountNum > balanceNum) {
      return 'Insufficient balance. You only have ₱${balanceNum.toStringAsFixed(2)}';
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
      return 'Enter Confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? firstNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (value.trim().length < 4) {
      return 'First name must be at least 4 characters';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\s\.\-']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Enter a valid first name';
    }
    return null;
  }

  static String? lastNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (value.trim().length < 4) {
      return 'Last name must be at least 4 characters';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\s\.\-']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Enter a valid last name';
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }
}
