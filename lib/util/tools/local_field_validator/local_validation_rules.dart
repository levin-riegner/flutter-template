interface class LocalValidationRules {
  final bool required;
  final int? minLength;
  final int? maxLength;
  final String? pattern;

  const LocalValidationRules({
    this.required = false,
    this.minLength,
    this.maxLength,
    this.pattern,
  });
}

// Create your own implementation of LocalValidationRules here
// Nullable fields are optional, pass them as null if you don't want to use them as validation rules

class EmailLocalValidationRules implements LocalValidationRules {
  /* Default pattern includes: 
      - Starts with a sequence of alphanumeric characters
      - Followed by an '@' symbol
      - Followed by another sequence of alphanumeric characters
      - Followed by a period
      - Ends with a sequence of alphanumeric characters representing the top-level domain
   */
  static const _defaultPattern =
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';

  @override
  int? get maxLength => 100;

  @override
  int? get minLength => 5;

  @override
  String? get pattern => _defaultPattern;

  @override
  bool get required => true;
}

class PasswordLocalValidationRules implements LocalValidationRules {
  /* Default pattern includes: 
      - At least 8 characters long
      - At least one uppercase letter
      - At least one lowercase letter
      - At least one digit
      - At least one special character
   */
  static const _defaultPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

  @override
  int? get maxLength => 24;

  @override
  int? get minLength => 6;

  @override
  String? get pattern => _defaultPattern;

  @override
  bool get required => true;
}
