import 'package:equatable/equatable.dart';
import 'package:flutter_template/presentation/auth/change_password/confirm/bloc/change_password_confirm_error.dart';

sealed class ChangePasswordConfirmState extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final String code;

  const ChangePasswordConfirmState({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.code,
  });

  ChangePasswordConfirmState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? code,
  });

  factory ChangePasswordConfirmState.empty() =>
      const ChangePasswordConfirmStateInitial(
        email: "",
        password: "",
        confirmPassword: "",
        code: "",
      );
}

class ChangePasswordConfirmStateInitial extends ChangePasswordConfirmState {
  const ChangePasswordConfirmStateInitial({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required super.code,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        code,
      ];

  @override
  ChangePasswordConfirmStateInitial copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? code,
  }) =>
      ChangePasswordConfirmStateInitial(
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        code: code ?? this.code,
      );
}

class ChangePasswordConfirmStateLoading extends ChangePasswordConfirmState {
  const ChangePasswordConfirmStateLoading({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required super.code,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        code,
      ];

  @override
  ChangePasswordConfirmStateLoading copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? code,
  }) =>
      ChangePasswordConfirmStateLoading(
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        code: code ?? this.code,
      );
}

class ChangePasswordConfirmStateSuccess extends ChangePasswordConfirmState {
  const ChangePasswordConfirmStateSuccess({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required super.code,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        code,
      ];

  @override
  ChangePasswordConfirmStateSuccess copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? code,
  }) =>
      ChangePasswordConfirmStateSuccess(
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        code: code ?? this.code,
      );
}

class ChangePasswordConfirmStateError extends ChangePasswordConfirmState {
  final ChangePasswordConfirmError error;

  const ChangePasswordConfirmStateError({
    required this.error,
    required super.email,
    required super.password,
    required super.confirmPassword,
    required super.code,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        code,
      ];

  @override
  ChangePasswordConfirmStateError copyWith({
    ChangePasswordConfirmError? error,
    String? email,
    String? password,
    String? confirmPassword,
    String? code,
  }) =>
      ChangePasswordConfirmStateError(
        error: error ?? this.error,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        code: code ?? this.code,
      );
}
