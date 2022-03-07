import 'package:dio/dio.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/api_key_interceptor.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/logging_interceptor.dart';
import 'package:flutter_template/data/shared/service/remote/interceptors/token_interceptor.dart';

abstract class Network {
  static Dio createHttpClient(
    final String baseUrl,
    final String apiKey,
    Future<String?> getBearerToken(),
  ) {
    // Create Dio Client
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl, 
      ),
    )
    ..interceptors.addAll(
        [
          // Add Bearer Token
          TokenInterceptor(getBearerToken()),
          // Add API Key
          ApiKeyInterceptor(apiKey),
          // Curl and logs
          LoggingInterceptor(),
        ],
    );

    return dio;
  }
}
