import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_error.freezed.dart';

@freezed
sealed class DataError with _$DataError implements Exception {
  const DataError._();

  const factory DataError.unknown({
    Object? error,
  }) = _Unknown;

  const factory DataError.apiError({
    required int code,
    required String reason,
  }) = _ApiError;

  const factory DataError.notFound() = _NotFound;

  const factory DataError.noInternet() = _NoInternet;

  // Client timeout (bad internet connection)
  const factory DataError.badInternet() = _BadInternet;

  // Receive timeout (server is overloaded)
  const factory DataError.serverTimeout() = _ServerTimeout;

  // Caused by an incorrect certificate
  const factory DataError.badCertificate() = _BadCertificate;

  @override
  String toString() {
    // The strings below are used as a fallback
    // prefer using the localizedMessage extension when presenting to the UI
    return when(
      unknown: (error) => error.toString(),
      apiError: (code, reason) => "($code) $reason",
      notFound: () => "Not found",
      noInternet: () => "No internet connection",
      badInternet: () => "Slow or no internet connection",
      serverTimeout: () => "Server timeout. Please try again later",
      badCertificate: () => "Incorrect certificate",
    );
  }
}
