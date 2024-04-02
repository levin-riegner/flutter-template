import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_api_model.g.dart';

@JsonSerializable()
class LoginApiModel implements DomainSerializable<dynamic> {
  // TODO: Add fields here 👇
  final String? placeholder;

  const LoginApiModel({
    this.placeholder,
  });

  factory LoginApiModel.fromJson(Map<String, dynamic> json) =>
      _$LoginApiModelFromJson(json);

  @override
  toDomain() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
