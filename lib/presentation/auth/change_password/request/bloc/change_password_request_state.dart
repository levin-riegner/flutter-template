import 'package:equatable/equatable.dart';
import 'package:flutter_template/presentation/auth/change_password/request/bloc/change_password_request_error.dart';

sealed class ChangePasswordRequestState extends Equatable {
  final String email;

  const ChangePasswordRequestState({
    required this.email,
  });

  ChangePasswordRequestState copyWith({
    String? email,
  });
}

class ChangePasswordRequestStateInitial extends ChangePasswordRequestState {
  const ChangePasswordRequestStateInitial({
    required super.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];

  @override
  ChangePasswordRequestStateInitial copyWith({
    String? email,
  }) =>
      ChangePasswordRequestStateInitial(
        email: email ?? this.email,
      );
}

class ChangePasswordRequestStateLoading extends ChangePasswordRequestState {
  const ChangePasswordRequestStateLoading({
    required super.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];

  @override
  ChangePasswordRequestStateLoading copyWith({
    String? email,
  }) =>
      ChangePasswordRequestStateLoading(
        email: email ?? this.email,
      );
}

class ChangePasswordRequestSuccess extends ChangePasswordRequestState {
  const ChangePasswordRequestSuccess({
    required super.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];

  @override
  ChangePasswordRequestSuccess copyWith({
    String? email,
  }) =>
      ChangePasswordRequestSuccess(
        email: email ?? this.email,
      );
}

class ChangePasswordStatePasswordStepSuccess
    extends ChangePasswordRequestState {
  const ChangePasswordStatePasswordStepSuccess({
    required super.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];

  @override
  ChangePasswordStatePasswordStepSuccess copyWith({
    String? email,
  }) =>
      ChangePasswordStatePasswordStepSuccess(
        email: email ?? this.email,
      );
}

class ChangePasswordRequestStateError extends ChangePasswordRequestState {
  final ChangePasswordRequestError error;

  const ChangePasswordRequestStateError({
    required this.error,
    required super.email,
  });

  @override
  List<Object?> get props => [
        error,
        email,
      ];

  @override
  ChangePasswordRequestStateError copyWith({
    ChangePasswordRequestError? error,
    String? email,
  }) =>
      ChangePasswordRequestStateError(
        error: error ?? this.error,
        email: email ?? this.email,
      );
}
