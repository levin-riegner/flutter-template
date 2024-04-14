import 'package:flutter/material.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';

class OtpResendView extends StatelessWidget {
  const OtpResendView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.otpNotReceivedLabel,
        ),
        DSTextButton(
          onPressed: () {},
          text: context.l10n.otpSendAgainButton,
        ),
      ],
    );
  }
}
