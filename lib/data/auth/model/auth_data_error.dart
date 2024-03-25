sealed class AuthDataError {}

class CodeExpired extends AuthDataError {}

class CodeMismatch extends AuthDataError {}

class InvalidParameterException extends AuthDataError {}

class LimitExceededException extends AuthDataError {}

class NotAuthorized extends AuthDataError {}

class UnknownError extends AuthDataError {
  final String error;

  UnknownError(this.error);
}

class UserNotFound extends AuthDataError {}

class UserNotConfirmedException extends AuthDataError {}

class UsernameExists extends AuthDataError {}
