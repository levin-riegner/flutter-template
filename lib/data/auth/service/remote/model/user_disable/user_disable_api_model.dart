import 'package:flutter_template/data/auth/model/user_disable_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_disable_api_model.g.dart';

@JsonSerializable()
class UserDisableApiModel extends AuthApiResponse {
  const UserDisableApiModel({
    super.status,
  });

  factory UserDisableApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserDisableApiModelFromJson(json);

  UserDisableModel toDomain() => UserDisableModel(
        status: status,
      );
}
