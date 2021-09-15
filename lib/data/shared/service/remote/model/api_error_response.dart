import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error_response.g.dart';

@JsonSerializable()
class ApiErrorResponse {
  final _Status? status;

  const ApiErrorResponse({
    this.status,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);
}

@JsonSerializable()
class _Status {
  final int? code;
  final List<String>? message;

  const _Status({
    this.code,
    this.message,
  });

  factory _Status.fromJson(Map<String, dynamic> json) =>
      _$StatusFromJson(json);
}
