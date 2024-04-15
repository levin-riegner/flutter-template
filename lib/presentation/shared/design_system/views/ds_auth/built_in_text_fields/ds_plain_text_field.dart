import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/ds_local_validable_text_field.dart';
import 'package:flutter_template/util/mixins/local_field_validation_mixin.dart';
import 'package:flutter_template/util/tools/local_field_validation/local_field_validator.dart';

class DSPlainTextField extends DSLocalValidableTextField {
  DSPlainTextField({
    super.key,
    super.focusNode,
    super.onChanged,
    super.onSubmitted,
    super.textInputAction,
    super.validationMode,
    required String labelText,
    Iterable<String>? autofillHints,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool autocorrect = true,
    bool enableSuggestions = true,
  }) : super(
          style: (context) => LocalValidableFieldStyle(
            labelText: labelText,
            errorMaxLines: Dimens.errorMaxLines,
            validatedIcon: const Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.green,
            ),
            autofillHints: autofillHints,
            enableSuggestions: enableSuggestions,
            autocorrect: autocorrect,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
          ),
        );

  @override
  LocalValidationOptions<LocalFieldValidator> get localValidationOptions =>
      LocalValidationOptions<NonEmptyLocalFieldValidator>(
        validator: NonEmptyLocalFieldValidator(),
      );
}
