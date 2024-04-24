import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/presentation/auth/change_password/confirm/bloc/change_password_confirm_cubit.dart';
import 'package:flutter_template/presentation/auth/change_password/confirm/bloc/change_password_confirm_error.dart';
import 'package:flutter_template/presentation/auth/change_password/confirm/bloc/change_password_confirm_state.dart';
import 'package:flutter_template/presentation/auth/otp_verification/widgets/otp_field.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_action_button_pair.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/alert_service.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/bloc/local_validable_cubit.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in/ds_password_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_divider.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/extensions/auth_data_error_extension.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/extensions/equatable_extension.dart';
import 'package:flutter_template/util/tools/email_opener.dart';
import 'package:go_router/go_router.dart';

// TODO: Replace with your custom designs, widgets and strings

class ChangePasswordConfirmPage extends StatelessWidget {
  final String? email;

  const ChangePasswordConfirmPage({
    super.key,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChangePasswordConfirmCubit>(
          create: (context) => ChangePasswordConfirmCubit(
            getIt<AuthRepository>(),
          )..setEmail(email),
        ),
        BlocProvider<LocalValidableCubit>(
          create: (context) => LocalValidableCubit(),
        ),
      ],
      child: ChangePasswordConfirmView(
        onPasswordChangedSuccess: () {
          // TODO: Redirect to your desired page after successful password change
          context.go(
            const LoginRoute().location,
          );
        },
      ),
    );
  }
}

class ChangePasswordConfirmView extends StatelessWidget {
  final String? title;
  final Function()? onPasswordChangedSuccess;

  const ChangePasswordConfirmView({
    super.key,
    this.title,
    this.onPasswordChangedSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordConfirmCubit, ChangePasswordConfirmState>(
      listener: (context, state) {
        context.read<LocalValidableCubit>().setCanSubmit(
              state.canSubmit,
            );

        if (state is ChangePasswordConfirmStateError) {
          AlertService.showAlert(
            type: AlertType.error,
            context: context,
            seconds: Dimens.alertDurationMedium,
            message: switch (state.error) {
              ChangePasswordConfirmUnknownError(error: String error) => error,
              ChangePasswordConfirmDataError(error: AuthDataError error) =>
                error.localizedMessage(context),
            },
          );

          context.read<ChangePasswordConfirmCubit>().resetState();
        }

        if (state is ChangePasswordConfirmStateSuccess) {
          AlertService.showAlert(
            context: context,
            seconds: Dimens.alertDurationXShort,
            message: context.l10n.passwordChangedSuccessAlertMessage,
          );

          if (onPasswordChangedSuccess != null) {
            Future.delayed(
              const Duration(seconds: Dimens.alertDurationXShort),
              onPasswordChangedSuccess!,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title ?? context.l10n.changePasswordPageTitle,
          ),
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: Dimens.marginXLarge,
          ),
          child: _ChangePasswordForm(),
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
              secondChild: BlocBuilder<ChangePasswordConfirmCubit,
                  ChangePasswordConfirmState>(
                builder: (context, state) =>
                    BlocBuilder<LocalValidableCubit, bool>(
                  builder: (context, canSubmit) => DSPrimaryButton(
                    isLoading: state is ChangePasswordConfirmStateLoading,
                    enabled: canSubmit,
                    onPressed: context
                        .read<ChangePasswordConfirmCubit>()
                        .changePassword,
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

class _ChangePasswordForm extends StatefulWidget {
  const _ChangePasswordForm();

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  late final FocusNode _codeFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;
  late final ValueNotifier<String?> _passwordBind;

  @override
  void initState() {
    super.initState();
    _passwordBind = ValueNotifier<String?>(null);
    _codeFocusNode = FocusNode()..requestFocus();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.changePasswordConfirmRationale,
          style: context.textTheme.bodyLarge,
        ),
        Dimens.boxMedium,
        OtpField(
          focusNode: _codeFocusNode,
          textInputAction: TextInputAction.next,
          onCompleted: (code) {
            _passwordFocusNode.requestFocus();

            context.read<ChangePasswordConfirmCubit>().setCode(code);
          },
          onLocalValidationFailure: () {
            context.read<ChangePasswordConfirmCubit>().setCode("");
          },
        ),
        Dimens.boxMedium,
        DSDivider(
          color: context.colorScheme.onBackground,
        ),
        Dimens.boxMedium,
        DSPasswordTextField(
          focusNode: _passwordFocusNode,
          labelText: context.l10n.newPasswordField,
          helperText: context.l10n.passwordRequirements,
          textInputAction: TextInputAction.next,
          onChanged: (val, isValid) {
            _passwordBind.value = val;

            if (isValid) {
              context.read<ChangePasswordConfirmCubit>().setPassword(val);
            } else {
              context.read<ChangePasswordConfirmCubit>().setPassword("");
            }
          },
          onSubmitted: (val, isValid) {
            _confirmPasswordFocusNode.requestFocus();
            _passwordBind.value = val;

            if (isValid) {
              context.read<ChangePasswordConfirmCubit>().setPassword(val);
            } else {
              context.read<ChangePasswordConfirmCubit>().setPassword("");
            }
          },
        ),
        Dimens.boxMedium,
        DSConfirmPasswordTextField(
          focusNode: _confirmPasswordFocusNode,
          labelText: context.l10n.confirmNewPasswordField,
          passwordBind: _passwordBind,
          helperText: context.l10n.confirmPasswordRequirements,
          textInputAction: TextInputAction.done,
          onChanged: (val, isValid) {
            if (isValid) {
              context
                  .read<ChangePasswordConfirmCubit>()
                  .setConfirmPassword(val);
            } else {
              context.read<ChangePasswordConfirmCubit>().setConfirmPassword("");
            }
          },
          onSubmitted: (val, isValid) {
            if (isValid) {
              context
                  .read<ChangePasswordConfirmCubit>()
                  .setConfirmPassword(val);
            } else {
              context.read<ChangePasswordConfirmCubit>().setConfirmPassword("");
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordBind.dispose();
    _codeFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }
}
