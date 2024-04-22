import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/model/create_account_model.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_cubit.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_error.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_state.dart';
import 'package:flutter_template/presentation/auth/widgets/auth_action_button_pair.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/alert_service.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/bloc/local_validable_cubit.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in/ds_email_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in/ds_password_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in/ds_plain_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/ds_local_validable_form.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_terms_and_conditions.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/extensions/auth_data_error_extension.dart';
import 'package:flutter_template/util/extensions/equatable_extension.dart';
import 'package:flutter_template/util/tools/custom_tabs_launcher.dart';
import 'package:go_router/go_router.dart';

// TODO: Replace with your custom designs, widgets and strings

class CreateAccountPage extends StatelessWidget {
  final String? title;
  final Function(CreateAccountModel createAccountModel)? onCreateAccountSuccess;

  const CreateAccountPage({
    super.key,
    this.title,
    this.onCreateAccountSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateAccountCubit, CreateAccountState>(
      listener: (context, state) {
        context.read<LocalValidableCubit>().setCanSubmit(
              state.canSubmit,
            );

        if (state is CreateAccountStateError) {
          AlertService.showAlert(
            type: AlertType.error,
            context: context,
            seconds: Dimens.alertDurationMedium,
            message: switch (state.error) {
              CreateAccountUnknownError(error: String error) => error,
              CreateAccountDataError(error: AuthDataError error) =>
                error.localizedMessage(context),
            },
          );

          context.read<CreateAccountCubit>().resetState();
        }

        if (state is CreateAccountStateSuccess) {
          if (onCreateAccountSuccess != null) {
            onCreateAccountSuccess!(
              state.createAccountData,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title ?? context.l10n.signUpPageTitle,
          ),
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: Dimens.marginXLarge,
          ),
          child: _CreateAccountForm(),
        ),
        persistentFooterButtons: [
          Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<CreateAccountCubit, CreateAccountState>(
                  builder: (context, state) => Align(
                    alignment: Alignment.centerLeft,
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) => context
                          .read<CreateAccountCubit>()
                          .setTermsAndConditionsAccepted(
                            value ?? false,
                          ),
                      value: state.termsAndConditionsAccepted,
                      title: DSTermsAndConditions(
                        text: context.l10n.termsAndConditionsAgreement,
                        patterns: [
                          LinkPattern(
                            pattern: context
                                .l10n.termsAndConditionsAgreementLinkPattern,
                            onPressed: () =>
                                CustomTabsLauncher.instance.launchURL(
                              getIt<Environment>()
                                  .webViewUrls
                                  .termsAndConditions,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AuthActionButtonPair(
                  firstChild:
                      BlocBuilder<CreateAccountCubit, CreateAccountState>(
                    builder: (context, state) =>
                        BlocBuilder<LocalValidableCubit, bool>(
                      builder: (context, canSubmit) => DSPrimaryButton(
                        isLoading: state is CreateAccountStateLoading,
                        enabled: canSubmit,
                        onPressed: () {
                          context.read<CreateAccountCubit>().createAccount(
                                email: state.email,
                                password: state.password,
                                confirmPassword: state.confirmPassword,
                                firstName: state.firstName,
                                lastName: state.lastName,
                                termsAndConditionsAccepted:
                                    state.termsAndConditionsAccepted,
                              );
                        },
                        text: context.l10n.signUpButton,
                      ),
                    ),
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
          ),
        ],
        persistentFooterAlignment: AlignmentDirectional.center,
      ),
    );
  }
}

class _CreateAccountForm extends StatefulWidget {
  const _CreateAccountForm();

  @override
  State<_CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<_CreateAccountForm> {
  late final FocusNode _firstNameFocusNode;
  late final FocusNode _lastNameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;
  late final ValueNotifier<String?> _passwordBind;

  @override
  void initState() {
    super.initState();
    _passwordBind = ValueNotifier<String?>(null);
    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return DSLocalValidableForm(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      verticalSpacing: Dimens.marginMedium,
      fields: [
        DSPlainTextField(
          focusNode: _firstNameFocusNode,
          labelText: context.l10n.firstNameField,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: true,
          keyboardType: TextInputType.name,
          autofillHints: const [
            AutofillHints.givenName,
          ],
          onChanged: (val, isValid) {
            if (isValid) {
              context.read<CreateAccountCubit>().setFirstName(val);
            } else {
              context.read<CreateAccountCubit>().setFirstName("");
            }
          },
          onSubmitted: (val, isValid) {
            _lastNameFocusNode.requestFocus();

            if (isValid) {
              context.read<CreateAccountCubit>().setFirstName(val);
            } else {
              context.read<CreateAccountCubit>().setFirstName("");
            }
          },
        ),
        DSPlainTextField(
          focusNode: _lastNameFocusNode,
          labelText: context.l10n.lastNameField,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: true,
          keyboardType: TextInputType.name,
          autofillHints: const [
            AutofillHints.familyName,
          ],
          onChanged: (val, isValid) {
            if (isValid) {
              context.read<CreateAccountCubit>().setLastName(val);
            } else {
              context.read<CreateAccountCubit>().setLastName("");
            }
          },
          onSubmitted: (val, isValid) {
            _emailFocusNode.requestFocus();

            if (isValid) {
              context.read<CreateAccountCubit>().setLastName(val);
            } else {
              context.read<CreateAccountCubit>().setLastName("");
            }
          },
        ),
        DSEmailTextField(
          focusNode: _emailFocusNode,
          textInputAction: TextInputAction.next,
          onChanged: (val, isValid) {
            if (isValid) {
              context.read<CreateAccountCubit>().setEmail(val);
            } else {
              context.read<CreateAccountCubit>().setEmail("");
            }
          },
          onSubmitted: (val, isValid) {
            _passwordFocusNode.requestFocus();

            if (isValid) {
              context.read<CreateAccountCubit>().setEmail(val);
            } else {
              context.read<CreateAccountCubit>().setEmail("");
            }
          },
        ),
        DSPasswordTextField(
          focusNode: _passwordFocusNode,
          helperText: context.l10n.passwordRequirements,
          textInputAction: TextInputAction.next,
          onChanged: (val, isValid) {
            _passwordBind.value = val;

            if (isValid) {
              context.read<CreateAccountCubit>().setPassword(val);
            } else {
              context.read<CreateAccountCubit>().setPassword("");
            }
          },
          onSubmitted: (val, isValid) {
            _confirmPasswordFocusNode.requestFocus();
            _passwordBind.value = val;

            if (isValid) {
              context.read<CreateAccountCubit>().setPassword(val);
            } else {
              context.read<CreateAccountCubit>().setPassword("");
            }
          },
        ),
        DSConfirmPasswordTextField(
          focusNode: _confirmPasswordFocusNode,
          labelText: context.l10n.confirmPasswordField,
          helperText: context.l10n.confirmPasswordRequirements,
          passwordBind: _passwordBind,
          textInputAction: TextInputAction.done,
          onChanged: (val, isValid) {
            if (isValid) {
              context.read<CreateAccountCubit>().setConfirmPassword(val);
            } else {
              context.read<CreateAccountCubit>().setConfirmPassword("");
            }
          },
          onSubmitted: (val, isValid) {
            if (isValid) {
              context.read<CreateAccountCubit>().setConfirmPassword(val);
            } else {
              context.read<CreateAccountCubit>().setConfirmPassword("");
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordBind.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }
}
