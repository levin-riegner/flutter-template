import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_text_field/ds_validable_text_field.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/mixins/local_validation_mixin.dart';
import 'package:flutter_template/util/tools/local_field_validator/local_field_validator.dart';
import 'package:flutter_template/util/tools/local_field_validator/local_validation_rules.dart';

class DSPasswordTextField extends DSLocalValidableTextField {
  final String? helperText;

  DSPasswordTextField({
    super.key,
    super.focusNode,
    super.onChanged,
    super.onSubmitted,
    super.textInputAction,
    this.helperText,
  }) : super(
          styleBuilder: (context, controller, isValid, isFocused, errorText) =>
              LocalValidableFieldStyle(
            textStyle: context.textTheme.bodyLarge,
            labelText: context.l10n.passwordField,
            errorMaxLines: Dimens.errorMaxLines,
            shouldObscureText: true,
            helperText: helperText,
            helperTextStyle: context.textTheme.labelSmall,
            validatedIcon: const Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.green,
            ),
            autofillHints: const [
              AutofillHints.password,
              AutofillHints.newPassword,
            ],
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            textCapitalization: TextCapitalization.none,
          ),
        );

  @override
  LocalValidationOptions<LocalFieldValidator<LocalValidationRules>>
      get localValidationOptions =>
          LocalValidationOptions<PasswordLocalFieldValidator>(
            enabled: true,
            validator: PasswordLocalFieldValidator(
              PasswordLocalValidationRules(),
            ),
          );
}
