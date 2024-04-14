import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_text_field/ds_validable_text_field.dart';
import 'package:flutter_template/util/mixins/local_validation_mixin.dart';
import 'package:flutter_template/util/tools/local_field_validator/local_field_validator.dart';
import 'package:flutter_template/util/tools/local_field_validator/local_validation_rules.dart';

class DSCalendarTextField extends DSLocalValidableTextField {
  final String labelText;

  DSCalendarTextField({
    required this.labelText,
    required super.onPressed,
    super.key,
    super.focusNode,
    super.onChanged,
    super.onSubmitted,
    super.textInputAction,
    super.validationMode,
  }) : super(
          styleBuilder: (context, controller, isValid, isFocused, errorText) =>
              LocalValidableFieldStyle(
            labelText: labelText,
            errorMaxLines: Dimens.errorMaxLines,
            validatedIcon: const Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.green,
            ),
          ),
        );

  @override
  LocalValidationOptions<LocalFieldValidator<LocalValidationRules>>
      get localValidationOptions => LocalValidationOptions(
            validator: NonEmptyLocalFieldValidator(
              NonEmptyLocalValidationRules(),
            ),
          );
}
