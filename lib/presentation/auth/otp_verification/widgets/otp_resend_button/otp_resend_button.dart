import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/presentation/auth/otp_verification/widgets/otp_resend_button/bloc/otp_resend_cubit.dart';
import 'package:flutter_template/presentation/auth/otp_verification/widgets/otp_resend_button/bloc/otp_resend_state.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';

class OtpResendButton extends StatefulWidget {
  final Future<void> Function() onResend;

  const OtpResendButton({
    super.key,
    required this.onResend,
  });

  @override
  State<OtpResendButton> createState() => _OtpResendButtonState();
}

class _OtpResendButtonState extends State<OtpResendButton> {
  late final OtpResendCubit _cubit;

  static const int _defaultCountdownSeconds = 60;

  @override
  void initState() {
    super.initState();
    _cubit = OtpResendCubit(
      countdownSeconds: _defaultCountdownSeconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.otpNotReceivedLabel,
        ),
        BlocBuilder<OtpResendCubit, OtpResendState>(
          bloc: _cubit,
          builder: (context, state) => DSTextButton(
            isLoading: state is OtpResendStateLoading,
            onPressed: state.isActive
                ? null
                : () => _cubit.start(
                      onResend: widget.onResend,
                    ),
            text: state.isActive
                ? context.l10n.otpSendAgainButtonCountdown(
                    state.countdownSeconds,
                  )
                : context.l10n.otpSendAgainButton,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
