import 'package:dio/dio.dart';
import 'dart:convert';

class LoggingInterceptor extends Interceptor {
  final bool preferCurl;

  LoggingInterceptor({this.preferCurl = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (preferCurl) {
      print(curl(options));
    } else {
      print("""REQUEST:
      URL: ${options.uri}\n
      Method: ${options.method} 
      Headers: ${json.encode(options.headers.map)}
      Data: ${json.encode(options.data)}
      <-- END HTTP
      """);
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("""ERROR:
    URL: ${err.requestOptions.uri}\n
    Method: ${err.requestOptions.method} 
    Headers: ${json.encode(err.response?.headers.map)}
    StatusCode: ${err.response?.statusCode}
    Data: ${json.encode(err.response?.data)}
    <-- END HTTP
        """);
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("""RESPONSE:
    URL: ${response.requestOptions.uri}
    Method: ${response.requestOptions.method}
    Headers: ${json.encode(response.headers.map)}
    Data: ${json.encode(response.data)}
        """);
    super.onResponse(response, handler);
  }

  String curl(RequestOptions options) {
    final method = options.method;
    final url = options.baseUrl.toString();
    final headers = options.headers;
    var curl = '';
    curl += 'curl';
    curl += ' -v';
    curl += ' -X $method';
    headers.forEach((k, v) {
      curl += ' -H \'$k: $v\'';
    });

    final String? body = options.data;
    if (body != null && body.isNotEmpty) {
      curl += ' -d \'$body\'';
    }

    curl += ' \"$url\"';
    return curl;
  }
}
