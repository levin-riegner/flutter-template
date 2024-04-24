import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final int? status;
  final String? token;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;

  const LoginModel({
    this.status,
    this.token,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  @override
  List<Object?> get props => [
        status,
        token,
        accessToken,
        refreshToken,
        expiresIn,
      ];
}
