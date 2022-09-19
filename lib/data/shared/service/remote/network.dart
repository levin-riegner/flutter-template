import 'package:dio/dio.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/api_key_interceptor.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/auth_token_interceptor.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/curl_interceptor.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/firebase_performance_interceptor.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/logging_interceptor.dart';
import 'package:logging_flutter/logging_flutter.dart';

abstract class Network {
  static Dio createHttpClient(
    final String baseUrl,
    final String apiKey,
    Future<String?> Function() getBearerToken, {
    required bool debugMode,
  }) {
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
          // Firebase Performance Monitoring
          if (!debugMode) FirebasePerformanceInterceptor(),
          // Curl
          CurlInterceptor(
            logPrint: (message) => Flogger.d(message, loggerName: "Curl"),
          ),
          // Logs
          LoggingInterceptor(
            logPrint: (message) =>
                Flogger.d(message.toString(), loggerName: "Dio"),
          ),
        ],
      );

    return dio;
  }
}
