import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_confirm_api_model.g.dart';

@JsonSerializable()
class UserConfirmApiModel implements DomainSerializable<dynamic> {
  // TODO: Add fields
  final String? placeholder;

  const UserConfirmApiModel({
    this.placeholder,
  });

  factory UserConfirmApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserConfirmApiModelFromJson(json);

  @override
  toDomain() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
