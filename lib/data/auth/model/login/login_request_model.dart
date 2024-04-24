import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request_model.g.dart';

@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}
