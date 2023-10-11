import 'package:equatable/equatable.dart';

import 'webview_urls.dart';

class Environment extends Equatable {
  final String environmentName;
  final bool internal;
  final AppId appId;
  final String appName;
  final String apiBaseUrl;
  final WebViewUrls webViewUrls;
  final String deepLinkScheme;
  final DatadogConfig datadogConfig;

  const Environment._({
    required this.environmentName,
    required this.internal,
    required this.appId,
    required this.appName,
    required this.apiBaseUrl,
    required this.webViewUrls,
    required this.deepLinkScheme,
    required this.datadogConfig,
  });

  factory Environment.staging() {
    // TODO: Replace with your constants
    return const Environment._(
      environmentName: "QA",
      internal: true,
      appId: AppId(
        androidAppId: "com.levinriegner.fluttertemplate.qa",
        iosAppId: "com.levinriegner.fluttertemplate.qa",
      ),
      appName: "FlutterTemplate QA",
      apiBaseUrl: "https://newsapi.org/v2",
      webViewUrls: WebViewUrls("https://staging.fluttertemplate.org"),
      deepLinkScheme: "templateqa",
      datadogConfig: DatadogConfig(clientToken: "fluttertemplate"),
    );
  }

  factory Environment.production() {
    // TODO: Replace with your constants
    return const Environment._(
      environmentName: "Production",
      internal: true,
      appId: AppId(
        androidAppId: "com.levinriegner.fluttertemplate.qa",
        iosAppId: "com.levinriegner.fluttertemplate.qa",
      ),
      appName: "FlutterTemplate",
      apiBaseUrl: "https://newsapi.org/v2",
      webViewUrls: WebViewUrls("https://fluttertemplate.org"),
      deepLinkScheme: "template",
      datadogConfig: DatadogConfig(clientToken: "fluttertemplate"),
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
        environmentName,
        internal,
        appId,
        appName,
        apiBaseUrl,
        webViewUrls,
        deepLinkScheme,
        datadogConfig,
      ];
}

class AppId extends Equatable {
  final String androidAppId;
  final String iosAppId;

  const AppId({
    required this.androidAppId,
    required this.iosAppId,
  });

  @override
  List<Object> get props => [androidAppId, iosAppId];
}

class DatadogConfig extends Equatable {
  final String clientToken;

  const DatadogConfig({
    required this.clientToken,
  });

  @override
  List<Object> get props => [clientToken];
}
