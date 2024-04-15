import 'package:flutter/material.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/presentation/auth/otp_verification/widgets/otp_resend_view.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_action_button_pair.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in_text_fields/ds_otp_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/util/tools/email_opener.dart';

// TODO: Replace with your custom designs, widgets and strings

class OtpVerificationPage extends StatelessWidget {
  final String? title;
  final String? rationale;
  final String? email;

  const OtpVerificationPage({
    super.key,
    this.title,
    this.rationale,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title ?? context.l10n.otpVerificationPageTitle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              rationale ??
                  (email != null
                      ? context.l10n.otpEmailVerificationRationale(email!)
                      : context.l10n.otpDefaultVerificationRationale),
            ),
            Dimens.boxMedium,
            const _OtpVerificationForm(),
          ],
        ),
      ),
      persistentFooterButtons: [
        AuthActionButtonPair(
          buttonSpacing: Dimens.marginSmall,
          firstChild: DSPrimaryButton(
            onPressed: EmailOpener.openDefaultApp,
            text: context.l10n.openEmailAppButton,
          ),
          secondChild: DSOutlineButton(
            onPressed: () {},
            text: context.l10n.confirmButton,
          ),
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}

class _OtpVerificationForm extends StatelessWidget {
  const _OtpVerificationForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSOtpTextField(
          labelText: context.l10n.otpField,
          textInputAction: TextInputAction.done,
          onSubmitted: (otp, isValid) {
            print("OTP $otp");
          },
        ),
        Dimens.boxMedium,
        const OtpResendView(),
      ],
    );
  }
}
