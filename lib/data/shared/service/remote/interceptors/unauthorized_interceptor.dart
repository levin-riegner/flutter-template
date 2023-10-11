import 'package:dio/dio.dart';
import 'package:logging_flutter/logging_flutter.dart';

class UnauthorizedInterceptor extends Interceptor {
  final Future<void> Function() _onUnauthorized;
  UnauthorizedInterceptor(this._onUnauthorized);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      if (err.response?.statusCode == 401) {
        Flogger.i("Received 401 Unauthorized for ${err.requestOptions.path}");
        await _onUnauthorized();
      } else {
        super.onError(err, handler);
      }
    } catch (e) {
      Flogger.w("Error handling 401 - $e");
      super.onError(err, handler);
    }
  }
}
