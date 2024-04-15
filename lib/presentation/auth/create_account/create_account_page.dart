import 'package:flutter/material.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_action_button_pair.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in_text_fields/ds_email_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in_text_fields/ds_password_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in_text_fields/ds_plain_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_terms_and_conditions.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/tools/custom_tabs_launcher.dart';
import 'package:go_router/go_router.dart';

// TODO: Replace with your custom designs, widgets and strings

class CreateAccountPage extends StatelessWidget {
  final String? title;

  const CreateAccountPage({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title ?? context.l10n.signUpPageTitle,
        ),
      ),
      body: const _CreateAccountForm(),
      persistentFooterButtons: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {},
                value: false,
                title: DSTermsAndConditions(
                  text: context.l10n.termsAndConditionsAgreement,
                  patterns: [
                    LinkPattern(
                      pattern:
                          context.l10n.termsAndConditionsAgreementLinkPattern,
                      onPressed: () => CustomTabsLauncher.instance.launchURL(
                        getIt<Environment>().webViewUrls.termsAndConditions,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AuthActionButtonPair(
              firstChild: DSPrimaryButton(
                onPressed: () {
                  // TODO: Perform sign up
                },
                text: context.l10n.signUpButton,
              ),
              secondChild: DSTextButton(
                alignment: Alignment.center,
                onPressed: () => context.go(
                  const LoginRoute().location,
                ),
                text: context.l10n.loginButton,
              ),
            ),
          ],
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}

class _CreateAccountForm extends StatefulWidget {
  const _CreateAccountForm({
    super.key,
  });

  @override
  State<_CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<_CreateAccountForm> {
  late final ValueNotifier<String?> _passwordBind;

  @override
  void initState() {
    super.initState();
    _passwordBind = ValueNotifier<String?>(null);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DSPlainTextField(
            labelText: "First Name",
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            enableSuggestions: true,
            keyboardType: TextInputType.name,
            autofillHints: const [
              AutofillHints.givenName,
            ],
          ),
          Dimens.boxMedium,
          DSPlainTextField(
            labelText: "Last Name",
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            enableSuggestions: true,
            keyboardType: TextInputType.name,
            autofillHints: const [
              AutofillHints.familyName,
            ],
          ),
          Dimens.boxMedium,
          DSEmailTextField(),
          Dimens.boxMedium,
          DSPasswordTextField(
            helperText: context.l10n.passwordRequirements,
            onChanged: (value, isValid) {
              _passwordBind.value = value;
            },
          ),
          Dimens.boxMedium,
          DSConfirmPasswordTextField(
            passwordBind: _passwordBind,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordBind.dispose();
    super.dispose();
  }
}
