import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_template/data/shared/model/error/data_error.dart';
import 'package:flutter_template/data/shared/service/remote/model/api_error_response.dart';
import 'package:logging_flutter/logging_flutter.dart';

mixin ApiResponseMapper {
  DataError mapToError(Object exception) {
    if (exception is DioException) {
      final statusCode = exception.response?.statusCode;
      if (statusCode != null) {
        Flogger.i("DioException api response with status code $statusCode");
      } else if (exception.error != null) {
        Flogger.i("DioException api response with error ${exception.error}");
      } else {
        Flogger.i("DioException api response with type ${exception.type}");
      }

      switch (statusCode) {
        case 404:
          return const DataError.notFound();
        default:
          try {
            // Try to use JSON error response from the API
            final apiErrorResponse =
                ApiErrorResponse.fromJson(exception.response!.data);
            return DataError.apiError(
              code: apiErrorResponse.status?.code ?? statusCode ?? -1,
              reason: apiErrorResponse.status?.message?.join(", ") ??
                  "Unknown error",
            );
          } catch (e) {
            // Try to use status message from the API
            if (exception.response?.statusMessage?.isNotEmpty == true) {
              return DataError.unknown(
                error:
                    "${statusCode != null ? "($statusCode) " : ""}${exception.response!.statusMessage}",
              );
            } else {
              // Use error from Dio
              switch (exception.type) {
                case DioExceptionType.connectionTimeout:
                  // Bad internet connection
                  return const DataError.badInternet();
                case DioExceptionType.sendTimeout:
                  // Bad internet connection
                  return const DataError.badInternet();
                case DioExceptionType.receiveTimeout:
                  // API Timeout
                  return const DataError.serverTimeout();
                case DioExceptionType.badResponse:
                  // This will probably be handled already in the API response error
                  return DataError.unknown(error: exception.error);
                case DioExceptionType.cancel:
                  // Request cancelled, this will never happen (not using cancelToken)
                  return DataError.unknown(error: exception.error);
                case DioExceptionType.unknown:
                  if (exception.error is SocketException) {
                    // This error could also mean the SERVER is DOWN.
                    // To verify we would need to do a request to another server
                    // and see if it fails too.
                    // For simplicity, we assume the server is NEVER down.
                    return const DataError.noInternet();
                  } else {
                    return DataError.unknown(error: exception.error);
                  }
                case DioExceptionType.badCertificate:
                  return const DataError.badCertificate();
                case DioExceptionType.connectionError:
                  return const DataError.noInternet();
              }
            }
          }
      }
    } else {
      Flogger.i("Exception api response with error $exception");
      return DataError.unknown(error: exception);
    }
  }
}
