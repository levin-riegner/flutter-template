import 'package:equatable/equatable.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_error.dart';
import 'package:flutter_template/util/extensions/string_extension.dart';

sealed class OtpVerificationState extends Equatable {
  final String code;
  final String email;
  final bool? resendSuccesful;

  const OtpVerificationState({
    required this.code,
    required this.email,
    this.resendSuccesful,
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
    super.resendSuccesful,
  });

  @override
  List<Object?> get props => [
        code,
        email,
      ];

  OtpVerificationStateInitial copyWith({
    String? code,
    String? email,
    bool? resendSuccesful,
  }) =>
      OtpVerificationStateInitial(
        code: code ?? this.code,
        email: email ?? this.email,
        resendSuccesful: resendSuccesful ?? this.resendSuccesful,
      );
}

class OtpVerificationStateLoading extends OtpVerificationState {
  const OtpVerificationStateLoading({
    required super.code,
    required super.email,
    super.resendSuccesful,
  });

  @override
  List<Object?> get props => [
        code,
        email,
      ];

  OtpVerificationStateLoading copyWith({
    String? code,
    String? email,
    bool? resendSuccesful,
  }) =>
      OtpVerificationStateLoading(
        code: code ?? this.code,
        email: email ?? this.email,
        resendSuccesful: resendSuccesful ?? this.resendSuccesful,
      );
}

class OtpVerificationStateSuccess<T> extends OtpVerificationState {
  final T data;

  const OtpVerificationStateSuccess({
    required super.code,
    required super.email,
    required this.data,
    super.resendSuccesful,
  });

  @override
  List<Object?> get props => [
        code,
        email,
        data,
      ];

  OtpVerificationStateSuccess copyWith({
    String? code,
    String? email,
    T? data,
    bool? resendSuccesful,
  }) =>
      OtpVerificationStateSuccess(
        code: code ?? this.code,
        email: email ?? this.email,
        data: data ?? this.data,
        resendSuccesful: resendSuccesful ?? this.resendSuccesful,
      );
}

class OtpVerificationStateError extends OtpVerificationState {
  final OtpVerificationError error;

  const OtpVerificationStateError({
    required this.error,
    required super.code,
    required super.email,
    super.resendSuccesful,
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
    bool? resendSuccesful,
  }) =>
      OtpVerificationStateError(
        error: error ?? this.error,
        code: code ?? this.code,
        email: email ?? this.email,
        resendSuccesful: resendSuccesful ?? this.resendSuccesful,
      );
}
