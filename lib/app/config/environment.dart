import 'webview_urls.dart';

class Environment {
  final String appId;
  final String appName;
  final String apiBaseUrl;
  final WebViewUrls webViewUrls;
  final String loggingUrl;
  final int loggingPort;
  final bool isInternal;
  final String name;

  Environment._(
    this.appId,
    this.appName,
    this.apiBaseUrl,
    this.webViewUrls,
    this.loggingUrl,
    this.loggingPort,
    this.isInternal,
    this.name,
  );

  factory Environment.staging() {
    // TODO: Replace with your constants
    return Environment._(
      "com.levinriegner.fluttertemplate.qa",
      "FlutterTemplate",
      "http://newsapi.org/v2",//"https://api-staging.fluttertemplate.org",
      WebViewUrls("https://staging.fluttertemplate.org"),
      "logsN.papertrailapp.com",
      12345,
      true,
      "Staging",
    );
  }

  factory Environment.production() {
    // TODO: Replace with your constants
    return Environment._(
      "com.levinriegner.fluttertemplate",
      "FlutterTemplate",
      "http://newsapi.org/v2",//"https://api.fluttertemplate.org",
      WebViewUrls("https://fluttertemplate.org"),
      "logsN.papertrailapp.com",
      12345,
      false,
      "Production",
    );
  }
}
