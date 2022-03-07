import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final Future<String?> getBearerToken;

  TokenInterceptor(this.getBearerToken);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getBearerToken;

    if (token != null) {
      options.headers["Authorization"] = token;
    }

    super.onRequest(options, handler);
  }
}
