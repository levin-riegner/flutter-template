import 'package:chopper/chopper.dart';
import 'package:flutter_template/data/shared/service/remote/model/api_error_response.dart';
import 'package:flutter_template/data/shared/service/remote/model/api_response.dart';
import 'package:logging_flutter/flogger.dart';

typedef T JsonFactory<T>(Map<String, dynamic> json);

class JsonSerializableConverter extends JsonConverter {
  final Map<Type, JsonFactory> factories;

  JsonSerializableConverter(this.factories);

  ApiResponse<T>? _decodeMap<T>(Map<String, dynamic> values) {
    /// Get jsonFactory using Type parameters
    /// if not found or invalid, throw error or return null
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! JsonFactory<T>) {
      /// throw serializer not found error;
      Flogger.error("Serializer not found for type $T");
      return null;
    }

    return ApiResponse<T>.fromJson(
        values, (json) => jsonFactory(json as Map<String, dynamic>));
  }

  List<T?> _decodeList<T>(List values) =>
      values.where((v) => v != null).map<T?>((v) => _decode<T>(v)).toList();

  dynamic _decode<T>(entity) {
    if (entity is Iterable) return _decodeList<T>(entity as List<dynamic>);

    if (entity is Map) return _decodeMap<T>(entity as Map<String, dynamic>);

    return entity;
  }

  @override
  Response<ResultType> convertResponse<ResultType, Item>(Response response) {
    // use [JsonConverter] to decode json
    final jsonRes = super.convertResponse(response);

    return jsonRes.copyWith<ResultType>(body: _decode<Item>(jsonRes.body));
  }

  @override
  // all objects should implements toJson method
  Request convertRequest(Request request) => super.convertRequest(request);

  Response convertError<ResultType, Item>(Response response) {
    // use [JsonConverter] to decode json
    final jsonRes = super.convertError(response);

    return jsonRes.copyWith<ApiErrorResponse>(
      body: ApiErrorResponse.fromJson(jsonRes.body),
    );
  }
}
