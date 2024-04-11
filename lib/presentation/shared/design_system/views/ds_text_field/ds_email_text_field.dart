import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_text_field/ds_validable_text_field.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/mixins/local_validation_mixin.dart';
import 'package:flutter_template/util/tools/local_field_validator/local_field_validator.dart';
import 'package:flutter_template/util/tools/local_field_validator/local_validation_rules.dart';

class DSEmailTextField extends DSLocalValidableTextField {
  DSEmailTextField({
    super.key,
    super.focusNode,
    super.onChanged,
    super.onSubmitted,
    super.textInputAction,
  }) : super(
          styleBuilder: (context, controller, isValid, isFocused, errorText) =>
              LocalValidableFieldStyle(
            textStyle: context.textTheme.bodyLarge,
            labelText: context.l10n.emailField,
            errorMaxLines: Dimens.errorMaxLines,
            validatedIcon: const Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.green,
            ),
            autofillHints: const [
              AutofillHints.email,
            ],
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
          ),
        );

  @override
  LocalValidationOptions<LocalFieldValidator<LocalValidationRules>>
      get localValidationOptions =>
          LocalValidationOptions<EmailLocalFieldValidator>(
            enabled: true,
            validator: EmailLocalFieldValidator(
              EmailLocalValidationRules(),
            ),
          );
}
