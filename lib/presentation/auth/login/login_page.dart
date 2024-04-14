import 'package:flutter/material.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/presentation/auth/login/widgets/forgot_password_button.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_action_button_pair.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_text_field/built_in/ds_email_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_text_field/built_in/ds_password_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_text_field/ds_validable_text_field.dart';
import 'package:go_router/go_router.dart';

// TODO: Replace with your custom designs, widgets and strings

class LoginPage extends StatelessWidget {
  final String? title;

  const LoginPage({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title ?? context.l10n.loginPageTitle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _LoginForm(),
            Dimens.boxXLarge,
            ForgotPasswordButton(
              onPressed: () => context.push(
                const ChangePasswordRoute().location,
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        AuthActionButtonPair(
          firstChild: DSPrimaryButton(
            onPressed: () {
              // TODO: Perform login
            },
            text: context.l10n.loginButton,
          ),
          secondChild: DSTextButton(
            alignment: Alignment.center,
            onPressed: () => context.push(
              const CreateAccountRoute().location,
            ),
            text: context.l10n.signUpButton,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DSEmailTextField(
          validationMode: LocalValidationMode.silent,
          textInputAction: TextInputAction.next,
        ),
        Dimens.boxMedium,
        DSPasswordTextField(
          validationMode: LocalValidationMode.silent,
        ),
      ],
    );
  }
}
