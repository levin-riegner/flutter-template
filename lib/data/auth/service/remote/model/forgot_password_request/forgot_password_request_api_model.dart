import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request_api_model.g.dart';

@JsonSerializable()
class ForgotPasswordRequestApiModel implements DomainSerializable<dynamic> {
  // TODO: Add fields here 👇
  final String? placeholder;

  const ForgotPasswordRequestApiModel({
    this.placeholder,
  });

  factory ForgotPasswordRequestApiModel.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestApiModelFromJson(json);

  @override
  toDomain() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
