import 'webview_urls.dart';

class Environment {
  final String appId;
  final String appName;
  final String apiBaseUrl;
  final String loggingUrl;
  final int loggingPort;
  final WebViewUrls webViewUrls;

  Environment._(
    this.appId,
    this.appName,
    this.apiBaseUrl,
    this.webViewUrls,
    this.loggingUrl,
    this.loggingPort,
  );

  factory Environment.staging() {
    // TODO: Replace with your constants
    return Environment._(
      "com.levinriegner.fluttertemplate.qa",
      "FlutterTemplate",
      "https://api-staging.fluttertemplate.org",
      WebViewUrls("https://staging.fluttertemplate.org"),
      "logsN.papertrailapp.com",
      12345,
    );
  }

  factory Environment.production() {
    // TODO: Replace with your constants
    return Environment._(
      "com.levinriegner.fluttertemplate",
      "FlutterTemplate",
      "https://api.fluttertemplate.org",
      WebViewUrls("https://fluttertemplate.org"),
      "logsN.papertrailapp.com",
      12345,
    );
  }
}
