import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';

class DSPasswordTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final String? errorText;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const DSPasswordTextField({
    this.focusNode,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  @override
  State<DSPasswordTextField> createState() => _DSPasswordTextFieldState();
}

class _DSPasswordTextFieldState extends State<DSPasswordTextField> {
  bool _passwordVisible = false;
  bool _passwordFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _passwordFocused = hasFocus;
        });
      },
      child: TextField(
        focusNode: widget.focusNode,
        obscureText: !_passwordVisible,
        style: context.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: context.l10n.passwordField,
          errorText: widget.errorText,
          errorMaxLines: Dimens.errorMaxLines,
          suffixIcon: ExcludeSemantics(
            child: IconButton(
              icon: _passwordVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              color: (widget.errorText?.isNotEmpty == true
                      ? context.theme.colorScheme.error
                      : context.theme.colorScheme.onBackground)
                  .withOpacity(_passwordFocused ? 1 : 0.5),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
        ),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        textInputAction: widget.textInputAction,
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
  }
}
