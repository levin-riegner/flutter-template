import 'package:flutter/material.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_action_button_pair.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_text_field/ds_email_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_text_field/ds_password_text_field.dart';

// TODO: Replace with your custom designs, widgets and strings

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
        ),
      ),
      body: const _LoginForm(),
      persistentFooterButtons: [
        AuthActionButtonPair(
          firstChild: DSPrimaryButton(
            onPressed: () {},
            text: "Login",
          ),
          secondChild: TextButton(
            onPressed: () {},
            child: const Text(
              "Sign Up",
            ),
          ),
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DSEmailTextField(),
          Dimens.boxMedium,
          DSPasswordTextField(
            helperText: context.l10n.passwordRequirements,
          ),
        ],
      ),
    );
  }
}
