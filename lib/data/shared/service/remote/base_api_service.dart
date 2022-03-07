import 'package:dio/dio.dart';
import 'package:logging_flutter/flogger.dart';
import 'package:flutter_template/data/shared/model/error/data_error.dart';

abstract class BaseApiService {
  Exception mapToError(Object exception) {
    if (exception is DioError) {
      Flogger.i(
        "Dio Error has occurred while making a request with status code",
        object: "${exception.response?.statusCode} || ${exception.response?.statusMessage}",
      );

      switch(exception.response?.statusCode) {
        case 404:
          return const NotFound();
        default: 
          return Unknown(error: exception.error);
      }
    } else {
      Flogger.i(
        "An unknown error has occurred while making a request",
        object: exception,
      );

      return Unknown(error: exception);
    }
  }
}
