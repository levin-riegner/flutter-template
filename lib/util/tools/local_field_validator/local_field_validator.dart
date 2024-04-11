import 'package:flutter/material.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/util/tools/local_field_validator/local_validation_rules.dart';

abstract class LocalFieldValidator<T extends LocalValidationRules> {
  final T validationRules;

  LocalFieldValidator(this.validationRules);

  // BuildContext is passed to allow for context-dependent actions like displaying a localized error message
  String? validate(
    BuildContext context,
    String? value,
    T validationRules,
  );
}

// Add your custom field validators here
// Create them by extending [LocalFieldValidator] and overriding the [validate] method
// Custom field validators must be tied to specific a specific [LocalValidationRules] subclass
// Head to lib/util/tools/local_field_validator/local_validation_rules.dart to create your custom validation rules
class EmailLocalFieldValidator
    extends LocalFieldValidator<EmailLocalValidationRules> {
  EmailLocalFieldValidator(super.validationRules);

  @override
  String? validate(
    BuildContext context,
    String? value,
    EmailLocalValidationRules validationRules,
  ) {
    String? error;

    if (validationRules.required) {
      if (value?.isEmpty == true) {
        error = context.l10n.emailErrorRequired;
      }
    }

    if (validationRules.minLength != null) {
      if (value?.isNotEmpty == true) {
        if (value!.length < validationRules.minLength!) {
          error = context.l10n.emailErrorMinLength(
            validationRules.minLength!,
          );
        }
      }
    }

    if (validationRules.maxLength != null) {
      if (value?.isNotEmpty == true) {
        if (value!.length > validationRules.maxLength!) {
          error = context.l10n.emailErrorMaxLength(
            validationRules.maxLength!,
          );
        }
      }
    }

    if (validationRules.pattern?.isNotEmpty == true) {
      if (value?.isNotEmpty == true) {
        if (!RegExp(validationRules.pattern!).hasMatch(value!)) {
          error = context.l10n.emailErrorInvalid;
        }
      }
    }

    return error;
  }
}

class PasswordLocalFieldValidator
    extends LocalFieldValidator<PasswordLocalValidationRules> {
  PasswordLocalFieldValidator(super.validationRules);

  @override
  String? validate(
    BuildContext context,
    String? value,
    PasswordLocalValidationRules validationRules,
  ) {
    String? error;

    if (validationRules.required) {
      if (value?.isEmpty == true) {
        error = context.l10n.passwordErrorRequired;
      }
    }

    if (validationRules.minLength != null) {
      if (value?.isNotEmpty == true) {
        if (value!.length < validationRules.minLength!) {
          error = context.l10n.passwordErrorMinLength(
            validationRules.minLength!,
          );
        }
      }
    }

    if (validationRules.maxLength != null) {
      if (value?.isNotEmpty == true) {
        if (value!.length > validationRules.maxLength!) {
          error = context.l10n.passwordErrorMaxLength(
            validationRules.maxLength!,
          );
        }
      }
    }

    if (validationRules.pattern?.isNotEmpty == true) {
      if (value?.isNotEmpty == true) {
        if (!RegExp(validationRules.pattern!).hasMatch(value!)) {
          error = context.l10n.passwordRequirements;
        }
      }
    }

    return error;
  }
}
