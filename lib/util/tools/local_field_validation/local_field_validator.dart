import 'package:flutter_template/util/tools/local_field_validation/local_validation_rules.dart';

abstract class LocalFieldValidator {
  final List<LocalValidationRule> validationRules;

  LocalFieldValidator(this.validationRules);

  List<String> validate(
    String? value,
  ) {
    final errors = <String>[];

    for (var rule in validationRules) {
      if (!rule.satisfies(value)) {
        errors.add(rule.id);
      }
    }

    return errors;
  }
}

// Add your custom field validators here
// Create them by extending [LocalFieldValidator] and passing the required [LocalValidationRules] subclass
// Custom field validators must be tied to specific a specific [LocalValidationRules] subclass
// Head to lib/util/tools/local_field_validator/local_validation_rules.dart to create your custom validation rules

class NonEmptyLocalFieldValidator extends LocalFieldValidator {
  NonEmptyLocalFieldValidator()
      : super(
          [
            RequiredRule(),
          ],
        );
}

class EmailLocalFieldValidator extends LocalFieldValidator {
  /* Default pattern includes: 
      - Starts with a sequence of alphanumeric characters or special characters (based on the RFC 5322 standard)
      - Followed by an '@' symbol
      - Followed by another sequence of alphanumeric characters
      - Followed by a period
      - Ends with a sequence of alphanumeric characters representing the top-level domain
   */
  static const _defaultPattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";

  EmailLocalFieldValidator()
      : super(
          [
            RequiredRule(),
            MinLengthRule(ruleValue: 5),
            PatternRule(ruleValue: _defaultPattern),
          ],
        );
}

class PasswordLocalFieldValidator extends LocalFieldValidator {
  /* Default pattern includes: 
      - At least one uppercase letter
      - At least one lowercase letter
      - At least one digit
      - At least one special character
   */
  static const _defaultPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]*$';

  PasswordLocalFieldValidator()
      : super(
          [
            RequiredRule(),
            MinLengthRule(ruleValue: 8),
            PatternRule(ruleValue: _defaultPattern),
          ],
        );
}

class OtpLocalFieldValidator extends LocalFieldValidator {
  /* Default pattern includes: 
      - Exactly 6 digits
   */
  static const _defaultPattern = r'^[0-9]{6}$';

  OtpLocalFieldValidator()
      : super(
          [
            RequiredRule(),
            MinLengthRule(ruleValue: 6),
            MaxLengthRule(ruleValue: 6),
            PatternRule(ruleValue: _defaultPattern)
          ],
        );
}
