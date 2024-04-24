import 'package:equatable/equatable.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_error.dart';

sealed class OtpVerificationState extends Equatable {
  final String code;
  final String email;
  final bool? resendSuccesful;

  const OtpVerificationState({
    required this.code,
    required this.email,
    this.resendSuccesful,
  });

  OtpVerificationState copyWith({
    String? code,
    String? email,
    bool? resendSuccesful,
  });

  factory OtpVerificationState.empty() => const OtpVerificationStateInitial(
        code: "",
        email: "",
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

  @override
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

  @override
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

  @override
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

  @override
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
