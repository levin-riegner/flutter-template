import 'package:dio/dio.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/api_key_interceptor.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/auth_token_interceptor.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/curl_interceptor.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/logging_interceptor.dart';
import 'package:logging_flutter/flogger.dart';

abstract class Network {
  static Dio createHttpClient(
    final String baseUrl,
    final String apiKey,
    Future<String?> Function() getBearerToken,
  ) {
    // Create Dio Client
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    )..interceptors.addAll(
        [
          // Add Bearer Token
          AuthTokenInterceptor(getBearerToken()),
          // Add Basic Auth
          // AuthBasicInterceptor(base64Credentials),
          // Add API Key
          ApiKeyInterceptor(apiKey),
          // Curl
          CurlInterceptor(
            logPrint: (message) => Flogger.d("Curl", object: message),
          ),
          // Logs
          LoggingInterceptor(
            logPrint: (message) => Flogger.d("Dio", object: message),
          ),
        ],
      );

    return dio;
  }
}
