import 'package:flutter_template/data/auth/model/login_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_response.dart';
import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_api_model.g.dart';

@JsonSerializable()
class LoginApiModel extends AuthApiResponse
    implements DomainSerializable<LoginModel> {
  final String? token;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;

  const LoginApiModel({
    super.status,
    this.token,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  factory LoginApiModel.fromJson(Map<String, dynamic> json) =>
      _$LoginApiModelFromJson(json);

  @override
  LoginModel toDomain() => LoginModel(
        status: status,
        token: token,
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
      );
}
