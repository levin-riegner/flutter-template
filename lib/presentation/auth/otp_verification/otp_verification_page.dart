import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_error.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_state.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/user_confirm/user_confirm_cubit.dart';
import 'package:flutter_template/presentation/auth/otp_verification/widgets/otp_resend_view.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_action_button_pair.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/alert_service.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/bloc/local_validable_cubit.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in_text_fields/ds_otp_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/util/extensions/auth_data_error_extension.dart';
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
    return BlocListener<UserConfirmCubit, OtpVerificationState>(
      listener: (context, state) {
        context.read<LocalValidableCubit>().setCanSubmit(
              state.canSubmit,
            );

        if (state is OtpVerificationStateError) {
          AlertService.showAlert(
            type: AlertType.error,
            context: context,
            seconds: Dimens.alertDurationMedium,
            message: switch (state.error) {
              OtpVerificationUnknownError(error: String error) => error,
              OtpVerificationDataError(error: AuthDataError error) =>
                error.localizedMessage(context),
            },
          );
        }
      },
      child: Scaffold(
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
            secondChild: BlocBuilder<UserConfirmCubit, OtpVerificationState>(
              builder: (context, state) =>
                  BlocBuilder<LocalValidableCubit, bool>(
                builder: (context, canSubmit) => DSOutlineButton(
                  isLoading: state is OtpVerificationStateLoading,
                  enabled: canSubmit,
                  onPressed: () {
                    context.read<UserConfirmCubit>().verifyCode(
                          state.code,
                        );
                  },
                  text: context.l10n.confirmButton,
                ),
              ),
            ),
          ),
        ],
        persistentFooterAlignment: AlignmentDirectional.center,
      ),
    );
  }
}

class _OtpVerificationForm extends StatelessWidget {
  const _OtpVerificationForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSOtpTextField(
          labelText: context.l10n.otpField,
          textInputAction: TextInputAction.done,
          onChanged: (val, isValid) {
            if (isValid) {
              context.read<UserConfirmCubit>().setCode(val);
            } else {
              context.read<UserConfirmCubit>().setCode("");
            }
          },
          onSubmitted: (val, isValid) {
            if (isValid) {
              context.read<UserConfirmCubit>().setCode(val);
            } else {
              context.read<UserConfirmCubit>().setCode("");
            }
          },
        ),
        Dimens.boxMedium,
        const OtpResendView(),
      ],
    );
  }
}
