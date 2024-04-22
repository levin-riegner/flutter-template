import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/model/user_confirm_model.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_error.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_state.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/user_confirm/user_confirm_cubit.dart';
import 'package:flutter_template/presentation/auth/otp_verification/widgets/otp_field.dart';
import 'package:flutter_template/presentation/auth/otp_verification/widgets/otp_resend_button/otp_resend_button.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_action_button_pair.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/alert_service.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/bloc/local_validable_cubit.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/util/extensions/auth_data_error_extension.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/extensions/equatable_extension.dart';
import 'package:flutter_template/util/tools/email_opener.dart';

// TODO: Replace with your custom designs, widgets and strings

class OtpVerificationPage extends StatefulWidget {
  final String? title;
  final String? rationale;
  final String? email;
  final Function(UserConfirmModel)? onVerificationSuccess;
  final bool sendCodeOnInit;

  const OtpVerificationPage({
    super.key,
    this.title,
    this.rationale,
    this.email,
    this.onVerificationSuccess,
    this.sendCodeOnInit = false,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  @override
  void initState() {
    super.initState();
    if (widget.sendCodeOnInit) {
      context.read<UserConfirmCubit>().sendCodeToEmail();
    }
  }

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

          context.read<UserConfirmCubit>().resetState();
        }

        if (state.resendSuccesful == true) {
          AlertService.showAlert(
            type: AlertType.success,
            context: context,
            seconds: Dimens.alertDurationMedium,
            message: context.l10n.otpResendSuccessMessage,
          );
        }

        if (state is OtpVerificationStateSuccess<UserConfirmModel>) {
          if (widget.onVerificationSuccess != null) {
            widget.onVerificationSuccess!(state.data);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title ?? context.l10n.otpVerificationPageTitle,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: Dimens.marginXLarge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.rationale ??
                    (widget.email != null
                        ? context.l10n
                            .otpEmailVerificationRationale(widget.email!)
                        : context.l10n.otpDefaultVerificationRationale),
              ),
              Dimens.boxMedium,
              const _OtpVerificationForm(),
            ],
          ),
        ),
        persistentFooterButtons: [
          Container(
            margin: EdgeInsets.only(
              bottom: context.mediaQuery.viewInsets.bottom,
            ),
            child: AuthActionButtonPair(
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
          ),
        ],
        persistentFooterAlignment: AlignmentDirectional.center,
      ),
    );
  }
}

class _OtpVerificationForm extends StatefulWidget {
  const _OtpVerificationForm();

  @override
  State<_OtpVerificationForm> createState() => _OtpVerificationFormState();
}

class _OtpVerificationFormState extends State<_OtpVerificationForm> {
  late final FocusNode _codeFocusNode;

  @override
  void initState() {
    super.initState();
    _codeFocusNode = FocusNode()..requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OtpField(
          focusNode: _codeFocusNode,
          onCompleted: (val) {
            context.read<UserConfirmCubit>().verifyCode(val);
          },
          onLocalValidationFailure: () {
            context.read<LocalValidableCubit>().setCanSubmit(false);
          },
          onLocalValidationSuccess: () {
            context.read<LocalValidableCubit>().setCanSubmit(true);
          },
        ),
        Dimens.boxMedium,
        OtpResendButton(
          onResend: context.read<UserConfirmCubit>().sendCodeToEmail,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _codeFocusNode.dispose();
    super.dispose();
  }
}
