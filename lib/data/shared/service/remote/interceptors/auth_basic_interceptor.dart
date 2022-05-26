import 'package:dio/dio.dart';

class AuthBasicInterceptor extends Interceptor {
  final String base64Credentials;

  AuthBasicInterceptor(this.base64Credentials);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers["Authorization"] = "Basic $base64Credentials";
    super.onRequest(options, handler);
  }
}
