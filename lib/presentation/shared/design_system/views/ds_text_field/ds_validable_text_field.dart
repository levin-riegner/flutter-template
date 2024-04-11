import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/mixins/local_validation_mixin.dart';
import 'package:flutter_template/util/tools/local_field_validator/local_field_validator.dart';
import 'package:flutter_template/util/tools/local_field_validator/local_validation_rules.dart';

typedef LocalValidableFieldStyleBuilder = LocalValidableFieldStyle Function(
  BuildContext context,
  TextEditingController controller,
  bool isValid,
  bool isFocused,
  String? errorText,
);

// Extend this class to create your own custom text fields with local validation
abstract class DSLocalValidableTextField extends StatefulWidget
    with LocalValidationMixin {
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final LocalValidableFieldStyleBuilder styleBuilder;

  const DSLocalValidableTextField({
    super.key,
    required this.styleBuilder,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<DSLocalValidableTextField> createState() =>
      _DSLocalValidableTextFieldState();

  @override
  LocalValidationOptions<LocalFieldValidator<LocalValidationRules>>
      get localValidationOptions;
}

class _DSLocalValidableTextFieldState<T extends DSLocalValidableTextField>
    extends State<T> {
  bool _isFocused = false;
  bool _fieldVisible = true;

  String? _localErrorText;

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _localErrorText == null && _controller.text.isNotEmpty;

    final fieldStyleBuilder = widget.styleBuilder(
      context,
      _controller,
      isValid,
      _isFocused,
      _localErrorText,
    );

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: TextField(
        controller: _controller,
        style: fieldStyleBuilder.textStyle,
        obscureText: fieldStyleBuilder.shouldObscureText && !_fieldVisible,
        decoration: InputDecoration(
          labelText: fieldStyleBuilder.labelText,
          errorText: _localErrorText,
          errorMaxLines: fieldStyleBuilder.errorMaxLines,
          errorStyle: fieldStyleBuilder.errorTextStyle,
          helperText: fieldStyleBuilder.helperText,
          helperMaxLines: fieldStyleBuilder.helperMaxLines,
          helperStyle: fieldStyleBuilder.helperTextStyle,
          suffixIcon: widget.localValidationOptions.enabled
              ? (fieldStyleBuilder.shouldObscureText
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isValid)
                          fieldStyleBuilder.validatedIcon ??
                              const SizedBox.shrink(),
                        ExcludeSemantics(
                          child: IconButton(
                            color: context.colorScheme.onBackground,
                            icon: _fieldVisible
                                ? fieldStyleBuilder.obscureTextActionIcon
                                : fieldStyleBuilder.showTextActionIcon,
                            onPressed: () {
                              setState(() {
                                _fieldVisible = !_fieldVisible;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : isValid
                      ? fieldStyleBuilder.validatedIcon
                      : null)
              : null,
        ),
        onChanged: widget.localValidationOptions.enabled
            ? (value) {
                if (widget.localValidationOptions.lookupType ==
                    LocalValidationLookup.realtime) {
                  setState(() {
                    _localErrorText =
                        widget.localValidationPredicate(context, value);
                  });
                }

                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              }
            : widget.onChanged,
        onSubmitted: widget.localValidationOptions.enabled
            ? (value) {
                if (widget.localValidationOptions.lookupType ==
                    LocalValidationLookup.submit) {
                  setState(() {
                    _localErrorText =
                        widget.localValidationPredicate(context, value);
                  });
                }

                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              }
            : widget.onSubmitted,
        textInputAction: widget.textInputAction,
        autofillHints: fieldStyleBuilder.autofillHints,
        enableSuggestions: fieldStyleBuilder.enableSuggestions,
        autocorrect: fieldStyleBuilder.autocorrect,
        keyboardType: fieldStyleBuilder.keyboardType,
        textCapitalization: fieldStyleBuilder.textCapitalization,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
      ];
}
