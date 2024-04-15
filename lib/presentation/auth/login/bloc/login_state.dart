import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/auth/model/login_model.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_error.dart';

sealed class LoginState extends Equatable {
  final String email;
  final String password;

  const LoginState({
    required this.email,
    required this.password,
  });
}

class LoginStateInitial extends LoginState {
  const LoginStateInitial({
    required super.email,
    required super.password,
  });

  @override
  List<Object?> get props => [
        email,
        password,
      ];

  LoginStateInitial copyWith({
    String? email,
    String? password,
  }) =>
      LoginStateInitial(
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

class LoginStateLoading extends LoginState {
  const LoginStateLoading({
    required super.email,
    required super.password,
  });

  @override
  List<Object?> get props => [
        email,
        password,
      ];

  LoginStateLoading copyWith({
    String? email,
    String? password,
  }) =>
      LoginStateLoading(
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

class LoginStateSuccess extends LoginState {
  final LoginModel data;

  const LoginStateSuccess({
    required this.data,
    required super.email,
    required super.password,
  });

  @override
  List<Object?> get props => [
        data,
      ];

  LoginStateSuccess copyWith({
    LoginModel? data,
    String? email,
    String? password,
  }) =>
      LoginStateSuccess(
        data: data ?? this.data,
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

class LoginStateError extends LoginState {
  final LoginError error;

  const LoginStateError({
    required this.error,
    required super.email,
    required super.password,
  });

  @override
  List<Object?> get props => [
        error,
      ];

  LoginStateError copyWith({
    LoginError? error,
    String? email,
    String? password,
  }) =>
      LoginStateError(
        error: error ?? this.error,
        email: email ?? this.email,
        password: password ?? this.password,
      );
}
