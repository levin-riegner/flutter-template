import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_text_field/ds_validable_text_field.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/mixins/local_field_validation_mixin.dart';
import 'package:flutter_template/util/tools/local_field_validation/local_field_validator.dart';

class DSPasswordTextField extends DSLocalValidableTextField {
  DSPasswordTextField({
    super.key,
    super.focusNode,
    super.onChanged,
    super.onSubmitted,
    super.textInputAction,
    super.validationMode,
    String? labelText,
    String? helperText,
  }) : super(
          style: (context) => LocalValidableFieldStyle(
            labelText: labelText ?? context.l10n.passwordField,
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
  LocalValidationOptions<LocalFieldValidator> get localValidationOptions =>
      LocalValidationOptions<PasswordLocalFieldValidator>(
        validator: PasswordLocalFieldValidator(),
      );
}

class DSConfirmPasswordTextField extends DSPasswordTextField {
  final ValueNotifier<String?> passwordBind;

  DSConfirmPasswordTextField({
    super.key,
    super.focusNode,
    super.onChanged,
    super.onSubmitted,
    super.textInputAction,
    super.labelText,
    super.helperText,
    super.validationMode,
    required this.passwordBind,
  });

  @override
  LocalValidationOptions<LocalFieldValidator> get localValidationOptions =>
      LocalValidationOptions<PasswordLocalFieldValidator>(
        validator: PasswordLocalFieldValidator(),
      );
}
