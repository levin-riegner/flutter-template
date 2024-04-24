import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_api_error.g.dart';

@JsonSerializable()
class AuthApiError {
  final String? error;
  final String? message;
  final int? status;

  AuthApiError({
    this.error,
    this.message,
    this.status,
  });

  factory AuthApiError.fromJson(Map<String, dynamic> json) =>
      _$AuthApiErrorFromJson(json);

  AuthDataError toDomain() {
    if (error != null) {
      if (error!.contains('NotAuthorizedException')) {
        return NotAuthorized();
      }

      if (error!.contains('UsernameExistsException')) {
        return UsernameExists();
      }

      if (error!.contains('CodeMismatchException')) {
        return CodeMismatch();
      }

      if (error!.contains('ExpiredCodeException')) {
        return CodeExpired();
      }

      if (error!.contains('UserNotFoundException')) {
        return UserNotFound();
      }

      if (error!.contains('InvalidParameterException')) {
        return InvalidParameterException();
      }

      if (error!.contains('LimitExceededException')) {
        return LimitExceededException();
      }

      if (error!.contains('UserNotConfirmedException')) {
        return UserNotConfirmedException();
      }

      throw UnknownError(
        error.toString(),
      );
    } else {
      return UnknownError(
        error.toString(),
      );
    }
  }
}
