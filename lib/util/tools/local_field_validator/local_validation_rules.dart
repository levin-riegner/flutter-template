// Create your own implementation of LocalValidationRules here by extending the interface
// Refer to the default implementations below for guidance on how to create your own
// Nullable fields are optional, pass them as null if you don't want to use them as validation rules
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

class NonEmptyLocalValidationRules implements LocalValidationRules {
  @override
  final bool required = true;

  @override
  final int? minLength = null;

  @override
  final int? maxLength = null;

  @override
  final String? pattern = null;
}

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
  int? get maxLength => null;

  @override
  int? get minLength => 5;

  @override
  String? get pattern => _defaultPattern;

  @override
  bool get required => true;
}

class PasswordLocalValidationRules implements LocalValidationRules {
  /* Default pattern includes: 
      - At least one uppercase letter
      - At least one lowercase letter
      - At least one digit
      - At least one special character
   */
  static const _defaultPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]*$';

  @override
  int? get maxLength => null;

  @override
  int? get minLength => 8;

  @override
  String? get pattern => _defaultPattern;

  @override
  bool get required => true;
}

class ConfirmPasswordLocalValidationRules extends NonEmptyLocalValidationRules {
  final String? password;

  ConfirmPasswordLocalValidationRules(
    this.password,
  );

  bool matches(String? value) => password == value;
}

class OtpLocalValidationRules implements LocalValidationRules {
  @override
  final bool required = true;

  @override
  final int? minLength = 6;

  @override
  final int? maxLength = 6;

  @override
  final String? pattern = r'^\d{6}$';
}
