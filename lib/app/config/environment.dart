import 'package:equatable/equatable.dart';

import 'webview_urls.dart';

class Environment extends Equatable {
  final String appId;
  final String appName;
  final String apiBaseUrl;
  final WebViewUrls webViewUrls;
  final String loggingUrl;
  final int loggingPort;
  final bool internal;
  final String name;
  final String deepLinkScheme;

  const Environment._({
    required this.appId,
    required this.appName,
    required this.apiBaseUrl,
    required this.webViewUrls,
    required this.loggingUrl,
    required this.loggingPort,
    required this.internal,
    required this.name,
    required this.deepLinkScheme,
  });

  factory Environment.staging() {
    // TODO: Replace with your constants
    return const Environment._(
      appId: "com.levinriegner.fluttertemplate.qa",
      appName: "FlutterTemplate QA",
      apiBaseUrl: "https://newsapi.org/v2",
      webViewUrls: WebViewUrls("https://staging.fluttertemplate.org"),
      loggingUrl: "logsN.papertrailapp.com",
      loggingPort: 12345,
      internal: true,
      name: "Staging",
      deepLinkScheme: "templateqa",
    );
  }

  factory Environment.production() {
    // TODO: Replace with your constants
    return const Environment._(
      appId: "com.levinriegner.fluttertemplate",
      appName: "FlutterTemplate",
      apiBaseUrl: "https://newsapi.org/v2",
      webViewUrls: WebViewUrls("https://fluttertemplate.org"),
      loggingUrl: "logsN.papertrailapp.com",
      loggingPort: 12345,
      internal: true,
      name: "Production",
      deepLinkScheme: "template",
    );
  }

  static List<Environment> values() {
    return [
      Environment.staging(),
      Environment.production(),
    ];
  }

  @override
  List<Object?> get props => [
        appId,
        appName,
        apiBaseUrl,
        webViewUrls,
        loggingUrl,
        loggingPort,
        internal,
        name,
        deepLinkScheme,
      ];
}
