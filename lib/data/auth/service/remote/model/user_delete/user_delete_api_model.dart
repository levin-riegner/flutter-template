import 'package:flutter_template/data/auth/model/user_delete_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_response.dart';
import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_delete_api_model.g.dart';

@JsonSerializable()
class UserDeleteApiModel extends AuthApiResponse
    implements DomainSerializable<UserDeleteModel> {
  const UserDeleteApiModel({
    super.status,
  });

  factory UserDeleteApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserDeleteApiModelFromJson(json);

  @override
  UserDeleteModel toDomain() => UserDeleteModel(
        status: status,
      );
}
