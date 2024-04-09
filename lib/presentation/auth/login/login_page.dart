import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_action_button_pair.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_text_fields/auth_text_fields.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';

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
    return const SingleChildScrollView(
      child: Column(
        children: [
          EmailTextField(),
          PasswordTextField(),
        ],
      ),
    );
  }
}
