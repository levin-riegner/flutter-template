import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_update_api_model.g.dart';

@JsonSerializable()
class UserUpdateApiModel implements DomainSerializable<dynamic> {
  // TODO: Add fields
  final String? placeholder;

  const UserUpdateApiModel({
    this.placeholder,
  });

  factory UserUpdateApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateApiModelFromJson(json);

  @override
  toDomain() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
