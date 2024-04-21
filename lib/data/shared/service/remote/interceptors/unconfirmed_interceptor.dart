import 'package:dio/dio.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_error.dart';
import 'package:logging_flutter/logging_flutter.dart';

class UnconfirmedInterceptor extends Interceptor {
  final Future<void> Function() _onUnconfirmed;

  UnconfirmedInterceptor(this._onUnconfirmed);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      final apiError = AuthApiError.fromJson(err.response?.data);
      final serializedError = apiError.toDomain();

      if (serializedError is UserNotConfirmedException) {
        Flogger.i(
            "Received UserNotConfirmedException for ${err.requestOptions.path}");
        await _onUnconfirmed();
      } else {
        super.onError(err, handler);
      }
    } catch (e) {
      Flogger.w("Error handling UserNotConfirmedException - $e");
      super.onError(err, handler);
    }
  }
}
