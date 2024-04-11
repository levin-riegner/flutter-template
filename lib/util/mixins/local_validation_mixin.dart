import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/util/tools/local_field_validator/local_field_validator.dart';

mixin LocalValidationMixin {
  LocalValidationOptions get localValidationOptions;

  // Override this method to provide your own validation to the field
  String? localValidationPredicate(BuildContext context, String? value) {
    if (!localValidationOptions.enabled) return null;

    return localValidationOptions.validator.validate(
      context,
      value,
      localValidationOptions.validator.validationRules,
    );
  }
}

final class LocalValidationOptions<T extends LocalFieldValidator>
    extends Equatable {
  final bool enabled;
  final T validator;
  final LocalValidationLookup lookupType;

  const LocalValidationOptions({
    required this.enabled,
    required this.validator,
    this.lookupType = LocalValidationLookup.realtime,
  });

  @override
  List<Object?> get props => [
        enabled,
        validator,
        lookupType,
      ];
}

// Realtime validation will trigger the validationPredicate method every time the field changes
// Submit validation will trigger the validationPredicate method only when the form is submitted
enum LocalValidationLookup {
  realtime,
  submit,
}
