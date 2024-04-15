import 'package:flutter/material.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in_text_fields/ds_password_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:go_router/go_router.dart';

// TODO: Replace with your custom designs, widgets and strings

class ChangePasswordPage extends StatelessWidget {
  final String? title;

  const ChangePasswordPage({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title ?? context.l10n.changePasswordPageTitle,
        ),
      ),
      body: const _ChangePasswordForm(),
      persistentFooterButtons: [
        DSPrimaryButton(
          onPressed: () => context.push(
            const OtpVerificationRoute().location,
          ),
          text: context.l10n.confirmButton,
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  const _ChangePasswordForm({
    super.key,
  });

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
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
          DSPasswordTextField(
            labelText: context.l10n.newPasswordField,
            helperText: context.l10n.passwordRequirements,
            textInputAction: TextInputAction.next,
            onChanged: (value, isValid) {
              _passwordBind.value = value;
            },
          ),
          Dimens.boxMedium,
          ValueListenableBuilder<String?>(
            valueListenable: _passwordBind,
            builder: (context, value, child) => DSConfirmPasswordTextField(
              labelText: context.l10n.confirmNewPasswordField,
              passwordBind: _passwordBind,
              helperText: context.l10n.confirmPasswordRequirements,
              textInputAction: TextInputAction.done,
            ),
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
