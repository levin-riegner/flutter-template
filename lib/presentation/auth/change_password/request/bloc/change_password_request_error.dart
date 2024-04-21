import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';

sealed class ChangePasswordRequestError extends Equatable {
  const ChangePasswordRequestError();
}

class ChangePasswordRequestUnknownError extends ChangePasswordRequestError {
  final String error;

  const ChangePasswordRequestUnknownError({
    required this.error,
  });

  @override
  List<Object?> get props => [
        error,
      ];
}

class ChangePasswordRequestDataError extends ChangePasswordRequestError {
  final AuthDataError error;

  const ChangePasswordRequestDataError({
    required this.error,
  });

  @override
  List<Object?> get props => [
        error,
      ];
}
