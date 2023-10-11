import 'package:dio/dio.dart';

class AcceptLanguageInterceptor extends Interceptor {
  final String languageCode;

  AcceptLanguageInterceptor(this.languageCode);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["Accept-Language"] = languageCode;

    super.onRequest(options, handler);
  }
}
