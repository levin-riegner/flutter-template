import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_cubit.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_error.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_state.dart';
import 'package:flutter_template/presentation/auth/login/widgets/forgot_password_button.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_action_button_pair.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/alert_service.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/bloc/local_validable_cubit.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in_text_fields/ds_email_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in_text_fields/ds_password_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/ds_local_validable_form.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/ds_local_validable_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/util/extensions/auth_data_error_extension.dart';
import 'package:flutter_template/util/extensions/equatable_extension.dart';
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
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        context.read<LocalValidableCubit>().setCanSubmit(
              state.canSubmit,
            );

        if (state is LoginStateError) {
          AlertService.showAlert(
            type: AlertType.error,
            context: context,
            seconds: Dimens.alertDurationMedium,
            message: switch (state.error) {
              LoginUnknownError(error: String error) => error,
              LoginDataError(error: AuthDataError error) =>
                error.localizedMessage(context),
            },
          );

          context.read<LoginCubit>().resetState();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title ?? context.l10n.loginPageTitle,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LoginForm(),
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
            firstChild: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) =>
                  BlocBuilder<LocalValidableCubit, bool>(
                builder: (context, canSubmit) => DSPrimaryButton(
                  isLoading: state is LoginStateLoading,
                  enabled: canSubmit,
                  onPressed: () {
                    context.read<LoginCubit>().performLogin(
                          state.email,
                          state.password,
                        );
                  },
                  text: context.l10n.loginButton,
                ),
              ),
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
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DSLocalValidableForm(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      verticalSpacing: Dimens.marginMedium,
      fields: [
        DSEmailTextField(
          onChanged: (val, isValid) {
            if (isValid) {
              context.read<LoginCubit>().setEmail(val);
            } else {
              context.read<LoginCubit>().setEmail("");
            }
          },
          onSubmitted: (val, isValid) {
            if (isValid) {
              context.read<LoginCubit>().setEmail(val);
            } else {
              context.read<LoginCubit>().setEmail("");
            }
          },
          validationMode: LocalValidationMode.silent,
          textInputAction: TextInputAction.next,
        ),
        DSPasswordTextField(
          onChanged: (val, isValid) {
            if (isValid) {
              context.read<LoginCubit>().setPassword(val);
            } else {
              context.read<LoginCubit>().setPassword("");
            }
          },
          onSubmitted: (val, isValid) {
            if (isValid) {
              context.read<LoginCubit>().setPassword(val);
            } else {
              context.read<LoginCubit>().setPassword("");
            }
          },
          validationMode: LocalValidationMode.silent,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
