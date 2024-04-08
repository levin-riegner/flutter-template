import 'package:json_annotation/json_annotation.dart';

part 'auth_api_response.g.dart';

@JsonSerializable()
class AuthApiResponse {
  final int? status;

  const AuthApiResponse({
    this.status,
  });

  factory AuthApiResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthApiResponseFromJson(json);
}
