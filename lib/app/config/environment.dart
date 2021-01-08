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

  static List<Environment> values() {
    return [Environment.staging(), Environment.production()];
  }

  @override
  bool operator ==(Object other) {
    if (other is Environment) {
      if (this.name == other.name && this.appId == other.appId && this.appName == other.appName && this.apiBaseUrl == other.apiBaseUrl) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  int get hashCode => name.hashCode;

}
