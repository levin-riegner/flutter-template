import 'package:flutter_template/data/shared/interface/domain_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_api_model.g.dart';

@JsonSerializable()
class RefreshTokenApiModel implements DomainSerializable<dynamic> {
  // TODO: Add fields
  final String? placeholder;

  const RefreshTokenApiModel({
    this.placeholder,
  });

  factory RefreshTokenApiModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenApiModelFromJson(json);

  @override
  toDomain() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
