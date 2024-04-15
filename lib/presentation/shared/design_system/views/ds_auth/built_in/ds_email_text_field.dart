import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/ds_local_validable_text_field.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/mixins/local_field_validation_mixin.dart';
import 'package:flutter_template/util/tools/local_field_validation/local_field_validator.dart';

class DSEmailTextField extends DSLocalValidableTextField {
  DSEmailTextField({
    super.key,
    super.focusNode,
    super.onChanged,
    super.onSubmitted,
    super.textInputAction,
    super.validationMode,
    String? labelText,
  }) : super(
          style: (context) => LocalValidableFieldStyle(
            textStyle: context.textTheme.bodyLarge,
            labelText: labelText ?? context.l10n.emailField,
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
  LocalValidationOptions<LocalFieldValidator> get localValidationOptions =>
      LocalValidationOptions<EmailLocalFieldValidator>(
        validator: EmailLocalFieldValidator(),
      );
}
