import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:logging_flutter/logging_flutter.dart';

class Datadog {
  const Datadog._();

  static Future<void> initialize({
    required DatadogConfig config,
    required String environment,
  }) async {
    await DatadogSdk.instance.initialize(
      DdSdkConfiguration(
        clientToken: config.clientToken,
        env: environment.toLowerCase(),
        site: DatadogSite.us1,
        trackingConsent: TrackingConsent.pending,
        nativeCrashReportEnabled: false,
        serviceName: "Flutter-$environment",
        loggingConfiguration: LoggingConfiguration(
          sendNetworkInfo: true,
          sendLogsToDatadog: true,
          printLogsToConsole: false,
          datadogReportingThreshold: Verbosity.info,
          loggerName: "Flutter-$environment",
        ),
        rumConfiguration: null,
      ),
    );
  }

  static Future<void> setTrackingConsent(bool? dataCollectionEnabled) async {
    TrackingConsent trackingConsent = TrackingConsent.pending;
    if (dataCollectionEnabled != null) {
      trackingConsent = dataCollectionEnabled
          ? TrackingConsent.granted
          : TrackingConsent.notGranted;
    }
    DatadogSdk.instance.setTrackingConsent(trackingConsent);
  }

  static Future<void> logRecord(String message, Level level) async {
    if (level == Level.SEVERE) {
      DatadogSdk.instance.logs?.error(message);
    } else if (level == Level.WARNING) {
      DatadogSdk.instance.logs?.warn(message);
    } else if (level == Level.INFO) {
      DatadogSdk.instance.logs?.info(message);
    } else {
      // Ignore other levels
    }
  }

  static Future<void> identify({
    required String userId,
    String? name,
    String? email,
  }) async {
    DatadogSdk.instance.setUserInfo(id: userId, name: name, email: email);
  }
}
