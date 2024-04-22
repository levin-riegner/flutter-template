import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/auth/model/create_account_model.dart';
import 'package:flutter_template/data/auth/model/login_model.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_error.dart';

sealed class CreateAccountState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool termsAndConditionsAccepted;

  const CreateAccountState({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.confirmPassword,
    required this.termsAndConditionsAccepted,
  });

  CreateAccountState copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? confirmPassword,
    bool? termsAndConditionsAccepted,
  });
}

class CreateAccountStateInitial extends CreateAccountState {
  const CreateAccountStateInitial({
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.confirmPassword,
    required super.termsAndConditionsAccepted,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        firstName,
        lastName,
        confirmPassword,
        termsAndConditionsAccepted,
      ];

  @override
  CreateAccountStateInitial copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? confirmPassword,
    bool? termsAndConditionsAccepted,
  }) =>
      CreateAccountStateInitial(
        email: email ?? this.email,
        password: password ?? this.password,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        termsAndConditionsAccepted:
            termsAndConditionsAccepted ?? this.termsAndConditionsAccepted,
      );
}

class CreateAccountStateLoading extends CreateAccountState {
  const CreateAccountStateLoading({
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.confirmPassword,
    required super.termsAndConditionsAccepted,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        firstName,
        lastName,
        confirmPassword,
        termsAndConditionsAccepted,
      ];

  @override
  CreateAccountStateLoading copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? confirmPassword,
    bool? termsAndConditionsAccepted,
  }) =>
      CreateAccountStateLoading(
        email: email ?? this.email,
        password: password ?? this.password,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        termsAndConditionsAccepted:
            termsAndConditionsAccepted ?? this.termsAndConditionsAccepted,
      );
}

class CreateAccountStateSuccess extends CreateAccountState {
  final CreateAccountModel createAccountData;

  const CreateAccountStateSuccess({
    required this.createAccountData,
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.confirmPassword,
    required super.termsAndConditionsAccepted,
  });

  @override
  List<Object?> get props => [
        createAccountData,
        email,
        password,
        firstName,
        lastName,
        confirmPassword,
        termsAndConditionsAccepted,
      ];

  @override
  CreateAccountStateSuccess copyWith({
    CreateAccountModel? createAccountData,
    LoginModel? loginData,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? confirmPassword,
    bool? termsAndConditionsAccepted,
  }) =>
      CreateAccountStateSuccess(
        createAccountData: createAccountData ?? this.createAccountData,
        email: email ?? this.email,
        password: password ?? this.password,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        termsAndConditionsAccepted:
            termsAndConditionsAccepted ?? this.termsAndConditionsAccepted,
      );
}

class CreateAccountStateError extends CreateAccountState {
  final CreateAccountError error;

  const CreateAccountStateError({
    required this.error,
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.confirmPassword,
    required super.termsAndConditionsAccepted,
  });

  @override
  List<Object?> get props => [
        error,
        email,
        password,
        firstName,
        lastName,
        confirmPassword,
        termsAndConditionsAccepted,
      ];

  @override
  CreateAccountStateError copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? confirmPassword,
    bool? termsAndConditionsAccepted,
  }) =>
      CreateAccountStateError(
        error: error,
        email: email ?? this.email,
        password: password ?? this.password,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        termsAndConditionsAccepted:
            termsAndConditionsAccepted ?? this.termsAndConditionsAccepted,
      );
}
