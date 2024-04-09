import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';

class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ForgotPasswordButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DSTextButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      text: "Forgot Password?",
    );
  }
}
