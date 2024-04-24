import 'package:equatable/equatable.dart';

class LoginRequestModel extends Equatable {
  final String email;
  final String password;
  final String? redirectUrl;

  const LoginRequestModel({
    required this.email,
    required this.password,
    this.redirectUrl,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        redirectUrl,
      ];

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'redirectUrl': redirectUrl,
      };
}
