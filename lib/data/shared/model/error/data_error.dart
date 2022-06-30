import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_error.freezed.dart';

@freezed
class DataError with _$DataError implements Exception {
  const factory DataError.unknown({
    Object? error,
  }) = _Unknown;

  const factory DataError.apiError({String? reason}) = _ApiError;

  const factory DataError.notFound() = _NotFound;
}
