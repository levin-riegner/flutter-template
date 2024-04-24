import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/auth/model/auth_token_model.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_error.dart';

sealed class LoginState extends Equatable {
  final String email;
  final String password;

  const LoginState({
    required this.email,
    required this.password,
  });

  LoginState copyWith({
    String? email,
    String? password,
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

  @override
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

  @override
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
  final AuthTokenModel data;

  const LoginStateSuccess({
    required this.data,
    required super.email,
    required super.password,
  });

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  LoginStateSuccess copyWith({
    AuthTokenModel? data,
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

  @override
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
