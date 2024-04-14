import 'package:flutter/material.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';

class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ForgotPasswordButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) => DSTextButton(
        alignment: Alignment.center,
        onPressed: onPressed,
        text: context.l10n.forgotPasswordButton,
      );
}
