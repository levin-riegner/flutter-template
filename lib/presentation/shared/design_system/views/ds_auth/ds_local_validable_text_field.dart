import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/conditional_parent_widget.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/mixins/local_field_validation_mixin.dart';
import 'package:flutter_template/util/tools/local_field_validation/local_field_validator.dart';
import 'package:flutter_template/util/tools/local_field_validation/local_validation_rules.dart';

// Realtime validation will trigger the validationPredicate method every time the field changes
// Submit validation will trigger the validationPredicate method only when the form is submitted
enum LocalValidationLookup {
  realtime,
  submit,
}

// Silent validation will not show any message below the field
// Explicit validation will show the error message below the field
// Disabled validation will not validate the field at all
enum LocalValidationMode {
  silent,
  explicit,
  disabled,
}

// Extend this class to create your own custom text fields with local validation
abstract class DSLocalValidableTextField extends StatefulWidget
    with LocalFieldValidationMixin {
  final FocusNode? focusNode;
  final Function(String, bool)? onChanged;
  final Function(String, bool)? onSubmitted;
  final TextInputAction? textInputAction;
  final LocalValidableFieldStyle Function(BuildContext) style;
  final LocalValidationLookup lookupMode;
  final LocalValidationMode validationMode;
  final bool autoSubmit;
  final Future Function()? onPressed;

  const DSLocalValidableTextField({
    super.key,
    required this.style,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.lookupMode = LocalValidationLookup.realtime,
    this.autoSubmit = false,
    this.validationMode = LocalValidationMode.explicit,
    this.onPressed,
  });

  @override
  State<DSLocalValidableTextField> createState() =>
      _DSLocalValidableTextFieldState();

  @override
  LocalValidationOptions<LocalFieldValidator> get localValidationOptions;
}

class _DSLocalValidableTextFieldState<T extends DSLocalValidableTextField>
    extends State<T> {
  bool _isFocused = false;
  final List<String> _localErrors = [];

  late bool _fieldVisible;
  late bool _isValid;

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    if (widget.autoSubmit) {
      _controller.addListener(_autoSubmitListener);
    }
  }

  void _autoSubmitListener() {
    if (_isValid) {
      widget.onSubmitted?.call(_controller.text, true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isValid = _localErrors.isEmpty && _controller.text.isNotEmpty;

    _fieldVisible = !widget.style(context).shouldObscureText;
  }

  @override
  Widget build(BuildContext context) {
    final fieldMaxLength = (widget
                .localValidationOptions.validator.validationRules
                .firstWhereOrNull((element) => element is MaxLengthRule)
            as MaxLengthRule?)
        ?.ruleValue;

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: ConditionalParentWidget(
        condition: widget.onPressed != null,
        parentBuilder: (child) => GestureDetector(
          onTap: () async {
            final value = (await widget.onPressed!()).toString();
            _controller.text = value;

            if (widget.validationMode != LocalValidationMode.disabled) {
              setState(() {
                _localErrors.clear();
                _localErrors.addAll(
                  widget.validateAndLocalize(
                    value,
                  ),
                );
              });
            }
          },
          child: AbsorbPointer(
            child: child,
          ),
        ),
        child: TextField(
          controller: _controller,
          style: widget.style(context).textStyle,
          obscureText:
              widget.style(context).shouldObscureText && !_fieldVisible,
          decoration: InputDecoration(
            labelText: widget.style(context).labelText,
            errorText: widget.validationMode == LocalValidationMode.explicit
                ? _localErrors.firstOrNull
                : null,
            errorMaxLines: widget.style(context).errorMaxLines,
            errorStyle: widget.style(context).errorTextStyle,
            helperText: widget.style(context).helperText,
            helperMaxLines: widget.style(context).helperMaxLines,
            helperStyle: widget.style(context).helperTextStyle,
            suffixIcon: widget.validationMode != LocalValidationMode.disabled
                ? (widget.style(context).shouldObscureText
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isValid &&
                              widget.validationMode ==
                                  LocalValidationMode.explicit)
                            widget.style(context).validatedIcon ??
                                const SizedBox.shrink(),
                          ExcludeSemantics(
                            child: IconButton(
                              color: context.colorScheme.onBackground,
                              icon: _fieldVisible
                                  ? widget.style(context).obscureTextActionIcon
                                  : widget.style(context).showTextActionIcon,
                              onPressed: () {
                                setState(() {
                                  _fieldVisible = !_fieldVisible;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : _isValid &&
                            widget.validationMode ==
                                LocalValidationMode.explicit
                        ? widget.style(context).validatedIcon
                        : null)
                : null,
          ),
          onChanged: widget.validationMode != LocalValidationMode.disabled
              ? (value) {
                  if (widget.lookupMode == LocalValidationLookup.realtime) {
                    setState(() {
                      _localErrors.clear();
                      _localErrors.addAll(
                        widget.validateAndLocalize(
                          value,
                        ),
                      );
                      _isValid =
                          _localErrors.isEmpty && _controller.text.isNotEmpty;
                    });
                  }

                  if (widget.onChanged != null) {
                    widget.onChanged!(value, _isValid);
                  }
                }
              : (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value, _isValid);
                  }
                },
          onSubmitted: widget.validationMode != LocalValidationMode.disabled
              ? (value) {
                  if (widget.lookupMode == LocalValidationLookup.submit) {
                    setState(() {
                      _localErrors.clear();
                      _localErrors.addAll(
                        widget.validateAndLocalize(
                          value,
                        ),
                      );
                      _isValid =
                          _localErrors.isEmpty && _controller.text.isNotEmpty;
                    });
                  }

                  if (widget.onSubmitted != null) {
                    widget.onSubmitted!(value, _isValid);
                  }
                }
              : (value) {
                  if (widget.onSubmitted != null) {
                    widget.onSubmitted!(value, _isValid);
                  }
                },
          textInputAction: widget.textInputAction,
          autofillHints: widget.style(context).autofillHints,
          enableSuggestions: widget.style(context).enableSuggestions,
          autocorrect: widget.style(context).autocorrect,
          keyboardType: widget.style(context).keyboardType,
          textCapitalization: widget.style(context).textCapitalization,
          maxLength: widget.validationMode != LocalValidationMode.disabled
              ? fieldMaxLength
              : null,
          buildCounter: widget.style(context).displayMaxLengthCounter == true
              ? null // Passing null defaults to showing Materials default counter Widget
              : (
                  context, {
                  required currentLength,
                  required isFocused,
                  required maxLength,
                }) =>
                  null,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _localErrors.clear();
    super.dispose();
  }
}

// These properties will be merged with the values specified in the app theme via [InputDecorationTheme.applyWithDefaults]
// So, for further customization, refer to your [InputDecorationTheme]
final class LocalValidableFieldStyle extends Equatable {
  final String? labelText;
  final int errorMaxLines;
  final int helperMaxLines;
  final Widget? validatedIcon;
  final TextStyle? textStyle;
  final TextStyle? errorTextStyle;
  final TextStyle? helperTextStyle;
  final Iterable<String>? autofillHints;
  final bool enableSuggestions;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool shouldObscureText;
  final Widget? prefixIcon;
  final Widget obscureTextActionIcon;
  final Widget showTextActionIcon;
  final String? helperText;
  final bool displayMaxLengthCounter;

  const LocalValidableFieldStyle({
    this.labelText,
    this.errorMaxLines = Dimens.errorMaxLines,
    this.helperMaxLines = Dimens.errorMaxLines,
    this.validatedIcon,
    this.textStyle,
    this.errorTextStyle,
    this.helperTextStyle,
    this.autofillHints,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.shouldObscureText = false,
    this.prefixIcon,
    this.obscureTextActionIcon = const Icon(Icons.visibility_off),
    this.showTextActionIcon = const Icon(Icons.visibility),
    this.helperText,
    this.displayMaxLengthCounter = false,
  });

  @override
  List<Object?> get props => [
        labelText,
        errorMaxLines,
        helperMaxLines,
        validatedIcon,
        textStyle,
        errorTextStyle,
        helperTextStyle,
        autofillHints,
        enableSuggestions,
        autocorrect,
        keyboardType,
        textCapitalization,
        shouldObscureText,
        prefixIcon,
        obscureTextActionIcon,
        showTextActionIcon,
        helperText,
        displayMaxLengthCounter,
      ];
}
