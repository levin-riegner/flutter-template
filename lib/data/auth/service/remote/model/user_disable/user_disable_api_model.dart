import 'package:flutter_template/data/auth/model/user_disable_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_response.dart';
import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_disable_api_model.g.dart';

@JsonSerializable()
class UserDisableApiModel extends AuthApiResponse
    implements DomainSerializable<UserDisableModel> {
  const UserDisableApiModel({
    super.status,
  });

  factory UserDisableApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserDisableApiModelFromJson(json);

  @override
  UserDisableModel toDomain() => UserDisableModel(
        status: status,
      );
}
