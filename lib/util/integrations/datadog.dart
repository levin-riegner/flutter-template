import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:logging_flutter/logging_flutter.dart';

class Datadog {
  static DatadogLogger? _logger;

  const Datadog._();

  static Future<void> initialize({
    required DatadogConfig config,
    required String environment,
  }) async {
    await DatadogSdk.instance.initialize(
      DatadogConfiguration(
        clientToken: config.clientToken,
        env: environment.toLowerCase(),
        site: DatadogSite.us1,
        nativeCrashReportEnabled: false,
        loggingConfiguration: DatadogLoggingConfiguration(),
        rumConfiguration: null,
      ),
      TrackingConsent.pending,
    );
    _logger = DatadogSdk.instance.logs?.createLogger(
      DatadogLoggerConfiguration(
        service: "Flutter-$environment",
        name: "Flutter-$environment",
        networkInfoEnabled: true,
        bundleWithRumEnabled: false,
        remoteLogThreshold: LogLevel.info,
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
      _logger?.error(message);
    } else if (level == Level.WARNING) {
      _logger?.warn(message);
    } else if (level == Level.INFO) {
      _logger?.info(message);
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
