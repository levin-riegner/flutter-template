import 'package:flutter/material.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';

extension AuthDataErrorLocalized on AuthDataError {
  String localizedMessage(BuildContext context) => switch (this) {
        CodeExpired() => context.l10n.authDataErrorCodeExpired,
        CodeMismatch() => context.l10n.authDataErrorCodeMismatch,
        InvalidParameterException() =>
          context.l10n.authDataErrorInvalidParameterException,
        LimitExceededException() =>
          context.l10n.authDataErrorLimitExceededException,
        NotAuthorized() => context.l10n.authDataErrorNotAuthorized,
        UnknownError() => context.l10n.defaultErrorMessage,
        UserNotFound() => context.l10n.authDataErrorUserNotFound,
        UserNotConfirmedException() =>
          context.l10n.authDataErrorUserNotConfirmedException,
        UsernameExists() => context.l10n.authDataErrorUsernameExists,
      };
}
