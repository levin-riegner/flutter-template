import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';

sealed class OtpVerificationError extends Equatable {
  const OtpVerificationError();
}

class OtpVerificationUnknownError extends OtpVerificationError {
  final String error;

  const OtpVerificationUnknownError({
    required this.error,
  });

  @override
  List<Object?> get props => [
        error,
      ];
}

class OtpVerificationDataError extends OtpVerificationError {
  final AuthDataError error;

  const OtpVerificationDataError({
    required this.error,
  });

  @override
  List<Object?> get props => [
        error,
      ];
}
