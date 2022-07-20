import 'package:dio/dio.dart';
import 'package:flutter_template/data/shared/model/error/data_error.dart';
import 'package:flutter_template/data/shared/service/remote/model/api_error_response.dart';
import 'package:logging_flutter/logging_flutter.dart';

abstract class BaseApiService {
  Exception mapToError(Object exception) {
    if (exception is DioError) {
      Flogger.i(
        "Dio Error has occurred while making a request with status code: ${exception.response?.statusCode} || ${exception.response?.statusMessage}",
      );

      switch (exception.response?.statusCode) {
        case 404:
          return const DataError.notFound();
        default:
          try {
            // Try to get error response from API
            final apiError =
                ApiErrorResponse.fromJson(exception.response!.data);
            return DataError.apiError(
              reason: apiError.status?.message?.join(", "),
            );
          } catch (e) {
            // Default error
            return DataError.unknown(error: exception.error);
          }
      }
    } else {
      Flogger.i(
        "An unknown error has occurred while making a request - $exception",
      );
      return DataError.unknown(error: exception);
    }
  }
}
