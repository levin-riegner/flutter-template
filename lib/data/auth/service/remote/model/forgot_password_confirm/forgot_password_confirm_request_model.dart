import 'package:equatable/equatable.dart';

class ForgotPasswordConfirmRequestModel extends Equatable {
  final String email;
  final String password;
  final String code;

  const ForgotPasswordConfirmRequestModel({
    required this.email,
    required this.password,
    required this.code,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        code,
      ];
}
