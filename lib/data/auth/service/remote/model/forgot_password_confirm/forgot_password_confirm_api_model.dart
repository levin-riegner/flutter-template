import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_confirm_api_model.g.dart';

@JsonSerializable()
class ForgotPasswordConfirmApiModel implements DomainSerializable<dynamic> {
  // TODO: Add fields here 👇
  final String? placeholder;

  const ForgotPasswordConfirmApiModel({
    this.placeholder,
  });

  factory ForgotPasswordConfirmApiModel.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordConfirmApiModelFromJson(json);

  @override
  toDomain() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
