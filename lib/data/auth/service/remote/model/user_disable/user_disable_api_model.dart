import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_disable_api_model.g.dart';

@JsonSerializable()
class UserDisableApiModel implements DomainSerializable<dynamic> {
  // TODO: Add fields
  final String? placeholder;

  const UserDisableApiModel({
    this.placeholder,
  });

  factory UserDisableApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserDisableApiModelFromJson(json);

  @override
  toDomain() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
