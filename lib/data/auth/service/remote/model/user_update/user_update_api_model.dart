import 'package:flutter_template/data/auth/model/user_update_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_response.dart';
import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_update_api_model.g.dart';

@JsonSerializable()
class UserUpdateApiModel extends AuthApiResponse
    implements DomainSerializable<UserUpdateModel> {
  const UserUpdateApiModel({
    super.status,
  });

  factory UserUpdateApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateApiModelFromJson(json);

  @override
  UserUpdateModel toDomain() => UserUpdateModel(
        status: status,
      );
}
