import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';

sealed class LoginError extends Equatable {
  const LoginError();
}

class LoginUnknownError extends LoginError {
  final String error;

  const LoginUnknownError({
    required this.error,
  });

  @override
  List<Object?> get props => [
        error,
      ];
}

class LoginDataError extends LoginError {
  final AuthDataError error;

  const LoginDataError({
    required this.error,
  });

  @override
  List<Object?> get props => [
        error,
      ];
}
