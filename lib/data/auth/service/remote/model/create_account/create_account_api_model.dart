import 'package:flutter_template/data/auth/model/create_account_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_response.dart';
import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_account_api_model.g.dart';

@JsonSerializable()
class CreateAccountApiModel extends AuthApiResponse
    implements DomainSerializable<CreateAccountModel> {
  final String? userId;

  const CreateAccountApiModel({
    super.status,
    this.userId,
  });

  factory CreateAccountApiModel.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountApiModelFromJson(json);

  @override
  CreateAccountModel toDomain() => CreateAccountModel(
        status: status,
        userId: userId,
      );
}
