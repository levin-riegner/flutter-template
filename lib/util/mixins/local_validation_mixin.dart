import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/util/tools/local_field_validator/local_field_validator.dart';

mixin LocalValidationMixin {
  LocalValidationOptions get localValidationOptions;

  String? localValidationPredicate(
    BuildContext context,
    String? value,
  ) =>
      localValidationOptions.validator.validate(
        context,
        value,
        localValidationOptions.validator.validationRules,
      );
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
