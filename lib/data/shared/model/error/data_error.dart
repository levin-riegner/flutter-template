import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_error.freezed.dart';

@freezed
class DataError with _$DataError implements Exception {
  const factory DataError.unknown({
    Object? error,
  }) = Unknown;

  const factory DataError.notFound() = NotFound;
}
