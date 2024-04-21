import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';

sealed class ChangePasswordConfirmError extends Equatable {
  const ChangePasswordConfirmError();
}

class ChangePasswordConfirmUnknownError extends ChangePasswordConfirmError {
  final String error;

  const ChangePasswordConfirmUnknownError({
    required this.error,
  });

  @override
  List<Object?> get props => [
        error,
      ];
}

class ChangePasswordConfirmDataError extends ChangePasswordConfirmError {
  final AuthDataError error;

  const ChangePasswordConfirmDataError({
    required this.error,
  });

  @override
  List<Object?> get props => [
        error,
      ];
}
