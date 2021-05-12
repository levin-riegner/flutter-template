import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse<T> {
  final String? status;
  final int? totalResults;
  final List<T>? data;

  // @JsonSerializable(fieldRename: FieldRename.snake)
  const ApiResponse({
    this.status,
    this.totalResults,
    this.data,
  });

  factory ApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);
}
