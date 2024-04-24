import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/presentation/auth/change_password/request/bloc/change_password_request_cubit.dart';
import 'package:flutter_template/presentation/auth/change_password/request/bloc/change_password_request_error.dart';
import 'package:flutter_template/presentation/auth/change_password/request/bloc/change_password_request_state.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/alert_service.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/bloc/local_validable_cubit.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/built_in/ds_email_text_field.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/ds_local_validable_form.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/extensions/auth_data_error_extension.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/extensions/equatable_extension.dart';
import 'package:go_router/go_router.dart';

// TODO: Replace with your custom designs, widgets and strings

class ChangePasswordRequestPage extends StatelessWidget {
  final String title;

  const ChangePasswordRequestPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChangePasswordRequestCubit>(
          create: (context) => ChangePasswordRequestCubit(
            getIt<AuthRepository>(),
          ),
        ),
        BlocProvider<LocalValidableCubit>(
          create: (context) => LocalValidableCubit(),
        ),
      ],
      child: ChangePasswordRequestView(
        title: title,
      ),
    );
  }
}

class ChangePasswordRequestView extends StatelessWidget {
  final String title;

  const ChangePasswordRequestView({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordRequestCubit, ChangePasswordRequestState>(
      listener: (context, state) {
        context.read<LocalValidableCubit>().setCanSubmit(
              state.canSubmit,
            );

        if (state is ChangePasswordRequestStateError) {
          AlertService.showAlert(
            type: AlertType.error,
            context: context,
            seconds: Dimens.alertDurationMedium,
            message: switch (state.error) {
              ChangePasswordRequestUnknownError(error: String error) => error,
              ChangePasswordRequestDataError(error: AuthDataError error) =>
                error.localizedMessage(context),
            },
          );

          context.read<ChangePasswordRequestCubit>().resetState();
        }

        if (state is ChangePasswordRequestSuccess) {
          context.push(
            ChangePasswordConfirmRoute(
              email: state.email,
            ).location,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
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
                context.l10n.changePasswordRequestRationale,
                style: context.textTheme.bodyLarge,
              ),
              Dimens.boxMedium,
              const _EmailInputForm(),
            ],
          ),
        ),
        persistentFooterButtons: [
          Container(
            margin: EdgeInsets.only(
              bottom: context.mediaQuery.viewInsets.bottom,
            ),
            child: BlocBuilder<ChangePasswordRequestCubit,
                ChangePasswordRequestState>(
              builder: (context, state) =>
                  BlocBuilder<LocalValidableCubit, bool>(
                builder: (context, canSubmit) => DSPrimaryButton(
                  isLoading: state is ChangePasswordRequestStateLoading,
                  enabled: canSubmit,
                  onPressed: context
                      .read<ChangePasswordRequestCubit>()
                      .sendCodeToEmail,
                  text: context.l10n.sendCodeButton,
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

class _EmailInputForm extends StatefulWidget {
  const _EmailInputForm();

  @override
  State<_EmailInputForm> createState() => _EmailInputFormState();
}

class _EmailInputFormState extends State<_EmailInputForm> {
  late final FocusNode _emailFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode()..requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return DSLocalValidableForm(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      fields: [
        DSEmailTextField(
          focusNode: _emailFocusNode,
          textInputAction: TextInputAction.done,
          onChanged: (val, isValid) {
            if (isValid) {
              context.read<ChangePasswordRequestCubit>().setEmail(val);
            } else {
              context.read<ChangePasswordRequestCubit>().setEmail("");
            }
          },
          onSubmitted: (val, isValid) {
            if (isValid) {
              context.read<ChangePasswordRequestCubit>().setEmail(val);
            } else {
              context.read<ChangePasswordRequestCubit>().setEmail("");
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }
}
