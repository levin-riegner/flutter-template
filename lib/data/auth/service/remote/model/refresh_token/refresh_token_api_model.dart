import 'package:flutter_template/data/auth/model/refresh_token_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_api_model.g.dart';

@JsonSerializable()
class RefreshTokenApiModel extends AuthApiResponse {
  final String? token;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;

  const RefreshTokenApiModel({
    super.status,
    this.token,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  factory RefreshTokenApiModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenApiModelFromJson(json);

  RefreshTokenModel toDomain() => RefreshTokenModel(
        status: status,
        token: token,
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
      );
}
