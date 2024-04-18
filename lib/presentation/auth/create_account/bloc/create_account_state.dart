import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/auth/model/create_account_model.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_error.dart';
import 'package:flutter_template/util/extensions/string_extension.dart';

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
  final CreateAccountModel data;

  const CreateAccountStateSuccess({
    required this.data,
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.confirmPassword,
    required super.termsAndConditionsAccepted,
  });

  @override
  List<Object?> get props => [
        data,
        email,
        password,
        firstName,
        lastName,
        confirmPassword,
        termsAndConditionsAccepted,
      ];
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
}