import 'package:flutter_template/data/auth/model/user_confirm_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_response.dart';
import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_confirm_api_model.g.dart';

@JsonSerializable()
class UserConfirmApiModel extends AuthApiResponse
    implements DomainSerializable<UserConfirmModel> {
  const UserConfirmApiModel({
    super.status,
  });

  factory UserConfirmApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserConfirmApiModelFromJson(json);

  @override
  UserConfirmModel toDomain() => UserConfirmModel(
        status: status,
      );
}
