import 'package:dio/dio.dart';

class AuthTokenInterceptor extends Interceptor {
  final Future<String?> Function() getBearerToken;

  AuthTokenInterceptor(this.getBearerToken);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getBearerToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    super.onRequest(options, handler);
  }
}
