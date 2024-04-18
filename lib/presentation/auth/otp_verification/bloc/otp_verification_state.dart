import 'package:equatable/equatable.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_error.dart';
import 'package:flutter_template/util/extensions/string_extension.dart';

sealed class OtpVerificationState extends Equatable {
  final String code;
  final String email;

  const OtpVerificationState({
    required this.code,
    required this.email,
  });

  bool get canSubmit => props.every(
        (element) {
          if (element is String) {
            return !element.isNullOrEmpty;
          } else if (element is bool) {
            return element;
          } else {
            return false;
          }
        },
      );
}

class OtpVerificationStateInitial extends OtpVerificationState {
  const OtpVerificationStateInitial({
    required super.code,
    required super.email,
  });

  @override
  List<Object?> get props => [
        code,
        email,
      ];

  OtpVerificationStateInitial copyWith({
    String? code,
    String? email,
  }) =>
      OtpVerificationStateInitial(
        code: code ?? this.code,
        email: email ?? this.email,
      );
}

class OtpVerificationStateLoading extends OtpVerificationState {
  const OtpVerificationStateLoading({
    required super.code,
    required super.email,
  });

  @override
  List<Object?> get props => [
        code,
        email,
      ];

  OtpVerificationStateLoading copyWith({
    String? code,
    String? email,
  }) =>
      OtpVerificationStateLoading(
        code: code ?? this.code,
        email: email ?? this.email,
      );
}

class OtpVerificationStateSuccess<T> extends OtpVerificationState {
  final T data;

  const OtpVerificationStateSuccess({
    required super.code,
    required super.email,
    required this.data,
  });

  @override
  List<Object?> get props => [
        code,
        email,
        data,
      ];

  OtpVerificationStateSuccess copyWith({
    String? code,
  }) =>
      OtpVerificationStateSuccess(
        code: code ?? this.code,
        email: email,
        data: data,
      );
}

class OtpVerificationStateError extends OtpVerificationState {
  final OtpVerificationError error;

  const OtpVerificationStateError({
    required this.error,
    required super.code,
    required super.email,
  });

  @override
  List<Object?> get props => [
        error,
        code,
        email,
      ];

  OtpVerificationStateError copyWith({
    OtpVerificationError? error,
    String? code,
    String? email,
  }) =>
      OtpVerificationStateError(
        error: error ?? this.error,
        code: code ?? this.code,
        email: email ?? this.email,
      );
}
