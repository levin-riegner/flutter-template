import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/model/auth_token_model.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_cubit.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_error.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_state.dart';
import 'package:flutter_template/presentation/auth/login/widgets/forgot_password_button.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_action_button_pair.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/alert_service.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/bloc/local_validable_cubit.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in/ds_email_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in/ds_password_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/ds_local_validable_form.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/ds_local_validable_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/extensions/auth_data_error_extension.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/extensions/equatable_extension.dart';
import 'package:go_router/go_router.dart';

// TODO: Replace with your custom designs, widgets and strings

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(
            getIt<AuthRepository>(),
          ),
        ),
        BlocProvider<LocalValidableCubit>(
          create: (context) => LocalValidableCubit(),
        ),
      ],
      child: LoginView(
        onLoginSuccess: (loginModel) {
          // TODO: Set actions after successful login
          // such as redirecting to the home page
          // or displaying a welcome dialog
          context.go(
            "/",
          );
        },
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  final String? title;
  final Function(AuthTokenModel loginModel)? onLoginSuccess;

  const LoginView({
    super.key,
    this.title,
    this.onLoginSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        context.read<LocalValidableCubit>().setCanSubmit(
              state.canSubmit,
            );

        if (state is LoginStateError) {
          if (state.error is LoginDataError) {
            if ((state.error as LoginDataError).error
                is UserNotConfirmedException) {
              context.push(
                const VerifyAccountRoute().location,
              );

              // Give some time for the navigation to complete and show alert
              await Future.delayed(const Duration(milliseconds: 500));
            }
          }

          if (context.mounted) {
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
        }

        if (state is LoginStateSuccess) {
          if (onLoginSuccess != null) {
            onLoginSuccess!(state.data);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title ?? context.l10n.loginPageTitle,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: Dimens.marginXLarge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LoginForm(),
              Dimens.boxXLarge,
              ForgotPasswordButton(
                onPressed: () => context.push(
                  const ResetPasswordRoute().location,
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          Container(
            margin: EdgeInsets.only(
              bottom: context.mediaQuery.viewInsets.bottom,
            ),
            child: AuthActionButtonPair(
              firstChild: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) =>
                    BlocBuilder<LocalValidableCubit, bool>(
                  builder: (context, canSubmit) => DSPrimaryButton(
                    isLoading: state is LoginStateLoading,
                    enabled: canSubmit,
                    onPressed: context.read<LoginCubit>().performLogin,
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
          ),
        ],
        persistentFooterAlignment: AlignmentDirectional.center,
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return DSLocalValidableForm(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      verticalSpacing: Dimens.marginMedium,
      fields: [
        DSEmailTextField(
          focusNode: _emailFocusNode,
          onChanged: (val, isValid) {
            if (isValid) {
              context.read<LoginCubit>().setEmail(val);
            } else {
              context.read<LoginCubit>().setEmail("");
            }
          },
          onSubmitted: (val, isValid) {
            _passwordFocusNode.requestFocus();

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
          focusNode: _passwordFocusNode,
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

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
