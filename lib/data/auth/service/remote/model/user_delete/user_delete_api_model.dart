import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_delete_api_model.g.dart';

@JsonSerializable()
class UserDeleteApiModel implements DomainSerializable<dynamic> {
  // TODO: Add fields here 👇
  final String? placeholder;

  const UserDeleteApiModel({
    this.placeholder,
  });

  factory UserDeleteApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserDeleteApiModelFromJson(json);

  @override
  toDomain() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
