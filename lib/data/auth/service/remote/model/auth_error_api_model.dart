import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_error_api_model.g.dart';

@JsonSerializable()
class AuthErrorApiModel implements DomainSerializable<AuthDataError> {
  final String? error;
  final int? status;

  AuthErrorApiModel({
    this.error,
    this.status,
  });

  factory AuthErrorApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthErrorApiModelFromJson(json);

  @override
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
