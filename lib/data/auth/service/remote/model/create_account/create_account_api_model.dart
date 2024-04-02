import 'package:flutter_template/data/auth/model/create_account_model.dart';
import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_account_api_model.g.dart';

@JsonSerializable()
class CreateAccountApiModel implements DomainSerializable<CreateAccountModel> {
  // TODO: Add fields here 👇
  final String? placeholder;

  const CreateAccountApiModel({
    this.placeholder,
  });

  factory CreateAccountApiModel.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountApiModelFromJson(json);

  @override
  CreateAccountModel toDomain() => CreateAccountModel(
        placeholder: placeholder,
      );
}
