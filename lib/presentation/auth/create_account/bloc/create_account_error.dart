import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';

sealed class CreateAccountError extends Equatable {
  const CreateAccountError();
}

class CreateAccountUnknownError extends CreateAccountError {
  final String error;

  const CreateAccountUnknownError({
    required this.error,
  });

  @override
  List<Object?> get props => [
        error,
      ];
}

class CreateAccountDataError extends CreateAccountError {
  final AuthDataError error;

  const CreateAccountDataError({
    required this.error,
  });

  @override
  List<Object?> get props => [
        error,
      ];
}
