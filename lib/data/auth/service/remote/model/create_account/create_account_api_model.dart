import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_account_api_model.g.dart';

@JsonSerializable()
class CreateAccountApiModel implements DomainSerializable<dynamic> {
  // TODO: Add fields
  final String? placeholder;

  const CreateAccountApiModel({
    this.placeholder,
  });

  factory CreateAccountApiModel.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountApiModelFromJson(json);

  @override
  toDomain() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
