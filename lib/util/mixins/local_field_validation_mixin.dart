import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/util/extensions/local_validation_rule_extension.dart';
import 'package:flutter_template/util/tools/local_field_validation/local_field_validator.dart';

mixin LocalFieldValidationMixin {
  LocalValidationOptions get localValidationOptions;

  List<String> validateAndLocalize(
    BuildContext context,
    String? value,
  ) {
    final unsatisfiedRules = localValidationOptions.validator.validate(value);

    return unsatisfiedRules
        .map((rule) => rule.defaultLocalizedMessage(context))
        .toList();
  }
}

final class LocalValidationOptions<T extends LocalFieldValidator>
    extends Equatable {
  final T validator;

  const LocalValidationOptions({
    required this.validator,
  });

  @override
  List<Object?> get props => [
        validator,
      ];
}
