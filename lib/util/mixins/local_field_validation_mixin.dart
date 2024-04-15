import 'package:equatable/equatable.dart';
import 'package:flutter_template/util/tools/local_field_validation/local_field_validator.dart';

mixin LocalFieldValidationMixin {
  LocalValidationOptions get localValidationOptions;

  List<String> validateAndLocalize(
    String? value,
  ) =>
      localValidationOptions.validator.validate(value);
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
